package melanesim.protocol;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.TimeZone;
import java.util.TreeSet;

import com.vividsolutions.jts.geom.Coordinate;

import data.C_Chronogram;
import data.C_Event;
import data.C_Parameters;
import data.C_ReadRaster;
import data.constants.I_ConstantPNMC_particules;
import data.constants.rodents.I_ConstantDodel;
import data.constants.rodents.I_ConstantGerbil;
import data.constants.rodents.I_ConstantNumeric;
import data.converters.C_ConvertGeographicCoordinates;
import melanesim.C_ContextCreator;
import melanesim.protocol.A_Protocol;
import melanesim.protocol.rodents.A_ProtocolFossorial;
import presentation.display.C_Background;
import presentation.display.C_CustomPanelSet;
//import presentation.epiphyte.C_InspectorEnergy;
import presentation.epiphyte.C_InspectorVegetation;
import repast.simphony.context.Context;
import repast.simphony.engine.environment.RunEnvironment;
import repast.simphony.engine.environment.RunState;
import repast.simphony.util.collections.IndexedIterable;
import thing.A_NDS;
import thing.C_BarnOwl;
import thing.C_RodentGerbil;
import thing.C_Vegetation;
import thing.I_SituatedThing;
import thing.dna.species.C_GenomeTytoAlba;
import thing.dna.species.plants.C_GenomeAcacia;
import thing.dna.species.plants.C_GenomeBalanites;
import thing.dna.species.plants.C_GenomeFabacea;
import thing.dna.species.plants.C_GenomePoacea;
import thing.dna.species.rodents.C_GenomeGerbillusNigeriae;
import thing.ground.C_Nest;
import thing.ground.C_SoilCell;
import thing.ground.C_SoilCellSavanna;

/** Initialize the simulation and manage inputs coming from the csv events file
 * @author J.Le Fur, 10.2014, rev. M.Sall 12.2015, JLF 02.2021, 03.2024 */
public class C_Protocol_PNMC_particules extends A_Protocol implements I_ConstantPNMC_particules {
	//
	// FIELDS
	//
	private C_ConvertGeographicCoordinates geographicCoordinateConverter = null;
	//
	// CONSTRUCTOR
	//
	public C_Protocol_PNMC_particules(Context<Object> ctxt) {
		super(ctxt);
		// Create and build the dataFromChrono from the csv file
		this.chronogram = new C_Chronogram(I_ConstantPNMC_particules.CHRONO_FILENAME);
		// facilityMap = new C_Background(0, -.4, -.4);
		// -10 plus gros, -5 plus petit
		this.facilityMap = null;
		I_ConstantNumeric.cellSize.set(0, CELL_SIZE);// Choose value of cell size
	}
	//
	// METHODS
	//
	@Override
	/** Initialize the protocol with the raster origin */
	public void initProtocol() {
		this.geographicCoordinateConverter = new C_ConvertGeographicCoordinates(new Coordinate(
				I_ConstantPNMC_particules.rasterLongitudeWest_LatitudeSouth_Udegree.get(0),
				I_ConstantPNMC_particules.rasterLongitudeWest_LatitudeSouth_Udegree.get(1)));
		this.initFixedParameters();
		super.initProtocol();
		if (C_Parameters.DISPLAY_MAP)
			if (this.facilityMap != null) this.facilityMap.contextualize(this.context, this.landscape);
	}
	@Override
	/** In gerbil protocol, the landscape raster values (i.e., affinity) contain the landcover values<br>
	 * author M.Sall 2017, rev. jlf 01.2018 */
	protected void initLandscape(Context<Object> context) {
		super.initLandscape(context);
		// Comment the following lines to undisplay soil cells, JLF 10.2015, 11.2015
		for (int i = 0; i < this.landscape.dimension_Ucell.width; i++) {
			for (int j = 0; j < this.landscape.dimension_Ucell.height; j++) {
				C_SoilCell cell = new C_SoilCell(this.landscape.getGrid()[i][j].getAffinity(), i, j);
				context.add(cell);
				this.landscape.setGridCell(i, j, cell);
				this.landscape.moveToLocation(cell, cell.getCoordinate_Ucs());
				// Homogenize background color once vegetation is set
				if (cell.getAffinity() != 0) {// 0 = water TODO number in source 2018.02 jlf
					this.landscape.getValueLayer().set(BACKGROUND_COLOR, i, j);
					cell.setAffinity(BACKGROUND_COLOR);
				}
			}
		}
	}
	@Override
	public void initCalendar() {
		// protocolCalendar.set(1999, Calendar.JANUARY, 1);
		protocolCalendar.set(1999, Calendar.JUNE, 1, I_ConstantDodel.TWILIGHT_END_Uhour + 1, 0);// To avoid being stuck at noon
																								// when time step>1day
	}
	@Override
	/** Default rodents are of the Gerbillus nigeriae species */
	public C_RodentGerbil createRodent() {
		return new C_RodentGerbil(new C_GenomeGerbillusNigeriae());
	}
	public C_BarnOwl createBarnOwl() {
		return new C_BarnOwl(new C_GenomeTytoAlba());
	}
	/** @see A_Protocol#manageOneEvent */
	public void manageOneEvent(C_Event event) {
		Coordinate coordinateCell_Ucs = null;
		if (event.whereX_Ucell == null) {// then: 1) suppose that y is also null, 2) double are values in decimal degrees
			coordinateCell_Ucs = this.geographicCoordinateConverter.convertCoordinate_Ucs(event.whereX_Udouble,
					event.whereY_Udouble);
			event.whereX_Ucell = (int) coordinateCell_Ucs.x;
			event.whereY_Ucell = (int) coordinateCell_Ucs.y;
		}
		if (coordinateCell_Ucs == null) coordinateCell_Ucs = new Coordinate(event.whereX_Ucell, event.whereY_Ucell);
		switch (event.type) {
			// Read monthly current grid east-west then north-south
			case CURRENT_EVENT :// file name example: 199901-PE-Rain.txt or 199901-TPE-Rain.txt
				String url; {
				Calendar calendar = Calendar.getInstance(TimeZone.getDefault());
				calendar.setTime(event.when_Ucalendar);
				// Month of simulation begin in 0 why we need to add 1 in the month value and put 0 before the month value between
				// 0 and 8
				if (calendar.get(Calendar.MONTH) < 9)
					url = RASTER_PATH_MELANESIA + currentSpeed_URL_suffix.get(0) + calendar.get(Calendar.YEAR) + "0"
							+ (calendar.get(Calendar.MONTH) + 1) + currentSpeed_URL_suffix.get(1);
				else
					url = RASTER_PATH_MELANESIA + currentSpeed_URL_suffix.get(0) + calendar.get(Calendar.YEAR)
							+ (calendar.get(Calendar.MONTH) + 1) + currentSpeed_URL_suffix.get(1);
				int[][] matriceLue = C_ReadRaster.txtRasterLoader(url);
				int imax = this.landscape.getDimension_Ucell().width;
				int jmax = this.landscape.getDimension_Ucell().height;
				// Change rain value of the cell with the value in the corresponding rain file
				for (int i = 0; i < imax; i++) {
					for (int j = 0; j < jmax; j++) {
						int value = matriceLue[i][j];
						((C_SoilCellSavanna) this.landscape.getGrid()[i][j]).setRainLevel(value);
					}
				}
			}
				break;
		}
		super.manageOneEvent(event);
	}
	@Override
	public String toString() {
		return "protocol PNMC particules";
	}
	// @Override
	// /** Display the map and dayNight icon if on, remove it if off. Only one map object. The switch can only go from on to off
	// and
	// * vice versa Version author J.Le Fur, 09.2014 rev: 01.2021 MS*/
	// protected void switchDisplayMap() {
	// if (C_Parameters.DISPLAY_MAP) this.facilityMap.contextualize(this.context, this.landscape);
	// super.initProtocol();// manage inspectors and files after everything
	// }
	@Override
	/** Color the map in black to see the overall distribution of burrows<br>
	 * Author J.Le Fur 10.2014 TODO JLF 2014.10 should be in presentation package ? */
	protected void blackMap() {
		for (int i = 0; i < this.landscape.getDimension_Ucell().getWidth(); i++)
			for (int j = 0; j < this.landscape.getDimension_Ucell().getHeight(); j++) {
				this.landscape.getValueLayer().set(BLACK_MAP_COLOR, i, j);
			}
	}
}