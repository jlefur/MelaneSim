package melanesim.protocol;

import java.util.Calendar;

import com.vividsolutions.jts.geom.Coordinate;

import data.C_Parameters;
import data.constants.I_ConstantPNMC_particules;
import data.converters.C_ConvertGeographicCoordinates;
import presentation.display.C_Background;
import repast.simphony.context.Context;
import thing.C_Plankton;
import thing.dna.C_GenomeAnimalia;
import thing.ground.C_BurrowSystem;
import thing.ground.C_LandPlot;
import thing.ground.C_SoilCell;
import thing.ground.I_Container;

/** Common voles' colonies within a dynamic agricultural landscape
 * @author J.Le Fur, A.Comte 03.2012 / J.Le Fur 07.2012, 07.2014 */

public class C_Protocol_PNMC_particules extends A_Protocol implements I_ConstantPNMC_particules {
	//
	// FIELDS
	//
	private C_ConvertGeographicCoordinates geographicCoordinateConverter = null;
	//
	// CONSTRUCTOR
	//
	/** Declare the inspectors, add them to the inspector list, declare them to the panelInitializer for indicators graphs<br>
	 * Author J.Le Fur 02.2013 */
	public C_Protocol_PNMC_particules(Context<Object> ctxt) {
		super(ctxt);
		// Position landplots at the barycentre of cells
		for (C_LandPlot lp : this.landscape.getAffinityLandPlots()) {
			double xx = 0., yy = 0.;
			for (C_SoilCell cell : lp.getCells()) {
				xx += cell.getCoordinate_Ucs().x;
				yy += cell.getCoordinate_Ucs().y;
			}
			xx = xx / lp.getCells().size();
			yy = yy / lp.getCells().size();
			this.landscape.moveToLocation(lp, new Coordinate(xx, yy));
			lp.setCurrentSoilCell(this.landscape.getGrid()[(int) xx][(int) yy]);
			lp.bornCoord_Umeter = this.landscape.getThingCoord_Umeter(lp.getCurrentSoilCell());
		}
		// facilityMap = new C_Background(-.05, 26, 27); //chize 1
		facilityMap = new C_Background(-.1, 27 - .4, 32 - .4); // chize 2
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
		this.initPopulations();
		super.initProtocol();
		if (C_Parameters.DISPLAY_MAP)
			if (this.facilityMap != null) this.facilityMap.contextualize(this.context, this.landscape);
	}
	/** Add plankton particle in the center of each cell of the grid at a specified interval - JLF 07.2024 */
	protected void initPopulations() {
		int particleCount = 0;
		int countHeight = 0;
		int countWidth = 0;
		int interval = 3; // interval where to post plankton cells
		java.awt.Dimension dim = this.landscape.getDimension_Ucell();
		int grid_width = (int) dim.getWidth();
		int grid_height = (int) dim.getHeight();
		I_Container cell;
		for (int i = 0; i < grid_width; i++) {
			if (countWidth == interval) {
				countHeight = 0;
				for (int j = 0; j < grid_height; j++) {
					if (countHeight == interval) {
						cell = this.landscape.getGrid()[i][j];
						if (cell.getAffinity() < 7) {// TODO number in source 2024.07.01 affinity min for land
							this.contextualizeNewThingInContainer(createPlankton(), cell);
							particleCount++;
						}
						countHeight = 0;
					}
					else countHeight++;
				}
				countWidth = 0;
			}
			else countWidth++;
		}
		System.out.println("C_Protocol_PNMC_particules.init: Population of " + particleCount
				+ " plankton agent(s) created and positioned at the center of each grid cell");
	}
	public C_Plankton createPlankton() {
		return new C_Plankton(new C_GenomeAnimalia());
	}

	/** Color the map in black to see the overall distribution of burrows<br>
	 * Author J.Le Fur 10.2014 TODO JLF 2014.10 should be in presentation package ? */
	protected void blackMap() {
		for (int i = 0; i < this.landscape.getDimension_Ucell().getWidth(); i++)
			for (int j = 0; j < this.landscape.getDimension_Ucell().getHeight(); j++) {
					if (this.landscape.getValueLayer().get(i, j) < 7) // marine area
						this.landscape.getValueLayer().set(BLACK_MAP_COLOR, i, j);
			}
	}
	@Override
	/** Check black map*/
	public void readUserParameters() {
		super.readUserParameters();
		boolean oldValueBlackMap = C_Parameters.BLACK_MAP;
		C_Parameters.BLACK_MAP = ((Boolean) C_Parameters.parameters.getValue("BLACK_MAP")).booleanValue();
		if (oldValueBlackMap != C_Parameters.BLACK_MAP) {
			if (C_Parameters.BLACK_MAP) this.blackMap();
			else if (this.landscape != null) this.landscape.resetCellsColor();
		}
	}

}
