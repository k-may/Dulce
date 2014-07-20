import processing.core.PApplet;


@SuppressWarnings("serial")
public class DulceApp extends PApplet{
	
	public DulceApp(){
		println("wtf?");
	}

	@Override
	public void setup() {
		size(displayWidth, displayHeight);
	}
	
	
	@Override
	public void draw() {
		background(255);
	}
	
	@Override
	public boolean sketchFullScreen() {
		return true;
	}
}
