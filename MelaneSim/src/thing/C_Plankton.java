package thing;
import thing.dna.I_DiploidGenome;
/** a simple structure containing a diploid genome, gets all the properties of Animal
 * @author J.LeFur 2024 */
public class C_Plankton extends A_Organism {

	public C_Plankton(I_DiploidGenome genome) {
		super(genome);
		this.setMyName("marine plankton" + NAMES_SEPARATOR + myId);
	}
	//
	// OVERRIDEN METHODS
	//
	/** The heart of SimMasto agents; realize specific actions (plancton do nothing yet), then super<br>
	 * @version jlf 2017,2018,2024 */
	@Override
	public void step_Utick() {
		super.step_Utick();
	}
}
