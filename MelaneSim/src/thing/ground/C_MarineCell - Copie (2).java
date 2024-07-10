package thing.ground;

import com.vividsolutions.jts.geom.Coordinate;

import data.converters.C_ConvertTimeAndSpace;
import thing.A_VisibleAgent;
import thing.C_Plankton;

/** Ocean unit used in MelaneSim
 * @author JLF 2024 */
public class C_MarineCell extends C_SoilCell {
	//
	// FIELDS
	//
	private double currentSpeedEastward_UmeterPerSecond, currentSpeedNorthward_UmeterPerSecond;
	//
	// CONSTRUCTOR
	//
	public C_MarineCell(int aff, int lineNo, int colNo) {
		super(aff, lineNo, colNo);
		this.currentSpeedEastward_UmeterPerSecond = 0.0;
		this.currentSpeedNorthward_UmeterPerSecond = 0.0;
	}
	//
	// METHOD
	//
	@Override
	/**Move planctonic occupants with the surface current speed - JLF 07.2024*/
	public void step_Utick() {
		super.step_Utick();
		if (this.currentSpeedEastward_UmeterPerSecond + this.currentSpeedNorthward_UmeterPerSecond != 0.0) {
			Object[] occupants = this.getOccupantList().toArray();// To avoid concurrent exception
			for (Object agent : occupants) {
				if (agent instanceof C_Plankton) {
					double currentSpeedEastward_UmeterPerTick = C_ConvertTimeAndSpace.convertSpeed_UspaceByTick(
							this.currentSpeedEastward_UmeterPerSecond, "m", "s");
					double currentSpeedNorthward_UmeterPerTick = C_ConvertTimeAndSpace.convertSpeed_UspaceByTick(
							this.currentSpeedNorthward_UmeterPerSecond, "m", "s");
					A_VisibleAgent.myLandscape.translate((A_VisibleAgent) agent, new Coordinate(
							currentSpeedEastward_UmeterPerTick, currentSpeedNorthward_UmeterPerTick));
				}
			}
		}
	}
	//
	// SETTERS & GETTERS
	//
	public void setCurrentEastward_UmeterPerSecond(double currentSpeedEastward_UmeterPerSecond) {
		this.currentSpeedEastward_UmeterPerSecond = currentSpeedEastward_UmeterPerSecond;
	}
	public void setCurrentNorthward_UmeterPerSecond(double currentSpeedNorthward_UmeterPerSecond) {
		this.currentSpeedNorthward_UmeterPerSecond = currentSpeedNorthward_UmeterPerSecond;
	}
	public double getCurrentEastward_UmeterPerSecond() {
		return currentSpeedEastward_UmeterPerSecond;
	}
	public double getCurrentNorthward_UmeterPerSecond() {
		return currentSpeedNorthward_UmeterPerSecond;
	}
}
