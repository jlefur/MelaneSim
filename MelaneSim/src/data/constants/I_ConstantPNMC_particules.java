package data.constants;

import java.util.ArrayList;

/** Gathers all variables since software specifications requires no numbers in the java sources <br>
 * @author Le Fur & Sall 09.2015, rev. JLF 02.2021, 03.2024 */
public interface I_ConstantPNMC_particules {

	// CHRONOGRAM FILE NAME
	public static String CHRONO_FILENAME = "/20240314_PNMC.jlf.csv";
	public static int CELL_SIZE = 245; // DEFAULT : 15 //Junk Value
	// SPATIAL PROJECTIONS NAMES
	// options: 1) ascii (provide a grid.csv), 2) any other string, image (/ provide e.g. one *.gif,.jpg,.bmp).
	public final String RASTER_MODE = "ascii";
	public final String GEOGRAPHY_NAME = "geography";// used in Melanesim.rs/context.xml
	public final String CONTINUOUS_SPACE_NAME = "space";// used in Melanesim.rs/context.xml
	public final String VALUE_LAYER_NAME = "valuegrid";// used in Melanesim.rs/context.xml
	// public final String proj_gridvalue2 = "valuegrid2";// used in networked/graphed landscapes
	public static final ArrayList<Double> rasterLongitudeWest_LatitudeSouth_Udegree = new ArrayList<Double>() {
		// stands for 12�18'28.3"N 17�31'48.5"W
		{
			add(156.);
			add(-26.5);
		}
		private static final long serialVersionUID = 1L;
	};
	public static final ArrayList<String> currentSpeed_URL_suffix = new ArrayList<String>() {
		{
			add("");
			add("");
		}
		private static final long serialVersionUID = 1L;
	};
	// CONSOLE OUTPUT
	public final boolean isError = true;
	public final boolean isNotError = false;
	// FILES & URLs //
	public final String CONSOLE_OUTPUT_FILE = "retour_console.txt";
	public final String CSV_PATH = "data_csv/melanesia/";
	public final String RASTER_PATH_MELANESIA = "data_raster/melanesia/";
	public final String OUTPUT_PATH = "data_output/";
	public final String REPAST_PATH = "MelaneSim.rs/";
	public final String EVENT_VALUE2_FIELD_SEPARATOR = ":";// used when event value2 is a list
	public final String HOUR_MINUTE_SEPARATOR = ":";// used when event value2 is a list
	public final String CSV_FIELD_SEPARATOR = ";";
	public final String NAMES_SEPARATOR = "_";// used when event value2 is a list

	// PROTOCOL NAMES - used in context creator
	public static final String PNMC = "PNMC";
	// EVENT TYPES CONSTANTS - used in chrono events
	public static final String CURRENT_EVENT = "Current";
	// Others
	public static final int BACKGROUND_COLOR = 38;
}