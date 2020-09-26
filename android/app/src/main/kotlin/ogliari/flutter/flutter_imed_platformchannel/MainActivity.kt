package ogliari.flutter.flutter_imed_platformchannel

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorManager
import android.os.Bundle
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

//activity = tela
//NATIVO KOTLIN
class MainActivity: FlutterActivity() {

    private val CHANNEL = "app/sensors"

    private lateinit var sensorManager: SensorManager

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        sensorManager = getSystemService(Context.SENSOR_SERVICE) as SensorManager
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        //criamos um ouvinte que responde a chamadas do código DART
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
                if (call.method.equals("checkSensors")) {
                    val deviceSensors: List<Sensor> = sensorManager.getSensorList(Sensor.TYPE_ALL)
                    result.success(deviceSensors.size)
                } else {
                    result.error(
                        "1",
                        "Método desconhecido",
                        "Não sabemos como responder a sua requisição")
                }
        }
    }


}
