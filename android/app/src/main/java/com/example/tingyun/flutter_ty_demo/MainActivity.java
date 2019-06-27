package com.example.tingyun.flutter_ty_demo;

import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
import com.networkbench.agent.impl.NBSAppAgent;

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    NBSAppAgent.setLicenseKey("094e27493fb54536bee392598b1a4544")
            .withLocationServiceEnabled(true).start(this);
  }
}
