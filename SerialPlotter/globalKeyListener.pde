//import com.github.kwhat.jnativehook.GlobalScreen;
//import com.github.kwhat.jnativehook.NativeHookException;
//import com.github.kwhat.jnativehook.keyboard.NativeKeyEvent;
//import com.github.kwhat.jnativehook.keyboard.NativeKeyListener;

static public class GlobalKeyListener implements NativeKeyListener {
  static boolean pressed = false;
  static String key;
  static int keyCode;

  static public void begin()
  {
    try {
      GlobalScreen.registerNativeHook();
    }
    catch (NativeHookException ex) {
      System.err.println("There was a problem registering the native hook.");
      System.err.println(ex.getMessage());

      System.exit(1);
    }

    GlobalScreen.addNativeKeyListener(new GlobalKeyListener());
  }

  public void nativeKeyPressed(NativeKeyEvent e) {
    //System.out.println("Key Pressed: " + NativeKeyEvent.getKeyText(e.getKeyCode()));
    //System.out.println("Key Pressed: " + e.getKeyCode());
    key = NativeKeyEvent.getKeyText(e.getKeyCode());
    keyCode = e.getKeyCode();
    pressed = true;

    if (e.getKeyCode() == NativeKeyEvent.VC_ESCAPE) {
      try {
        GlobalScreen.unregisterNativeHook();
      }
      catch (NativeHookException nativeHookException) {
        nativeHookException.printStackTrace();
      }
    }
  }

  public void nativeKeyReleased(NativeKeyEvent e) {
    //System.out.println("Key Released: " + NativeKeyEvent.getKeyText(e.getKeyCode()));
    key = NativeKeyEvent.getKeyText(e.getKeyCode());
    keyCode = e.getKeyCode();
    pressed = false;
  }

  //public void nativeKeyTyped(NativeKeyEvent e) {
  //  System.out.println("Key Typed: " + e.getKeyText(e.getKeyCode()));
  //}
}
