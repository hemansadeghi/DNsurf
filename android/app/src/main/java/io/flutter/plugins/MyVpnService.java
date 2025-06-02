
package com.example.dns_connector;

import android.net.VpnService;
import android.content.Intent;
import android.os.ParcelFileDescriptor;
import android.util.Log;

import java.io.IOException;
import java.net.InetAddress;

public class MyVpnService extends VpnService {
    private static final String TAG = "MyVpnService";
    private ParcelFileDescriptor vpnInterface = null;

    public static final String DNS1 = "DNS1";
    public static final String DNS2 = "DNS2";

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        String dns1 = intent.getStringExtra(DNS1);
        String dns2 = intent.getStringExtra(DNS2);

        try {
            if (vpnInterface != null) {
                vpnInterface.close();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        Builder builder = new Builder();
        builder.setSession("DNSConnectorVPN")
                .addAddress("10.0.0.2", 32)
                .addDnsServer(dns1)
                .addDnsServer(dns2)
                .allowFamily(android.system.OsConstants.AF_INET);

        vpnInterface = builder.establish();
        Log.i(TAG, "VPN Started with DNS: " + dns1 + ", " + dns2);
        return START_STICKY;
    }

    @Override
    public void onDestroy() {
        try {
            if (vpnInterface != null) {
                vpnInterface.close();
                vpnInterface = null;
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        super.onDestroy();
        Log.i(TAG, "VPN Stopped");
    }
}
