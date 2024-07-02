package thing;
import thing.dna.I_DiploidGenome;
/** a simple structure containing a diploid genome, gets all the properties of Animal
 * @author J.LeFur 2024 */
public class C_Plankton extends A_Animal {

	public C_Plankton(I_DiploidGenome genome) {
		super(genome);
		this.setMyName("marine plankton" + NAMES_SEPARATOR + myId);
	}
	@Override
	/** set new random move then move */
	protected void actionForage() {
		this.nextMove_Umeter.x = 1000.;
		this.nextMove_Umeter.y = 1.;
		this.actionMove();
	}
	@Override
	/** no danger checking for plankton, jlf 2024 */
	protected void checkDanger() {}
}