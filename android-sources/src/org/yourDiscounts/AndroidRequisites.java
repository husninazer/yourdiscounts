package org.yourDiscounts;

import android.content.Intent;
import android.net.Uri;

import android.location.LocationManager;

import android.content.Context;

import android.os.Environment;


//import com.google.firebase.iid.FirebaseInstanceId;
//import com.google.firebase.messaging.FirebaseMessaging;

import  	android.util.Log;

class JavaToCpp
{
    // declare the native method
    public static native void fcmNewNotification();
}

public class AndroidRequisites extends org.qtproject.qt5.android.bindings.QtActivity
{
    private static AndroidRequisites m_instance;

    public AndroidRequisites()
    {
        m_instance = this;
    }

    public static void openSettings()
    {
        m_instance.startActivity(new Intent(android.provider.Settings.ACTION_SETTINGS)); // Open Settings Screen
    }

    public static void openLocationSettings()
    {
        m_instance.startActivity(new Intent(android.provider.Settings.ACTION_LOCATION_SOURCE_SETTINGS)); // Open Location Settings Screen
    }

    public static String locationProviders()
    {
        // String locationProviders = Settings.Secure.getString(getContentResolver(), Settings.Secure.LOCATION_PROVIDERS_ALLOWED); // This may return the list of providers but is obsolete. Might be useful if more than gps and network. Not tested yet.

        String status = "";
        LocationManager manager = (LocationManager) m_instance.getSystemService(Context.LOCATION_SERVICE);

        if (manager.isProviderEnabled(LocationManager.GPS_PROVIDER))
            status = status + "GPS;";

        if (manager.isProviderEnabled(LocationManager.NETWORK_PROVIDER))
            status = status + "NETWORK";

        return status;
    }


    public static String primaryStorageStatus()
    {
        String state = Environment.getExternalStorageState();
        String status = "";
        if ( Environment.MEDIA_MOUNTED.equals(state) ) //  ) {  // we can read and write the External Storage...
            status += "WRITE;";
        else if (Environment.MEDIA_MOUNTED_READ_ONLY.equals(state))
            status += "READ;";

        return status;
    }

    public static String primaryStoragePath()
    {
        return Environment.getExternalStorageDirectory().getAbsolutePath();
    }

    public static String primaryPrivateStoragePath()    // Only difference with primaryStoragePath is that the contents of this path gets deleted if the user uninstall the app.
    {
        return primaryStoragePath();
        // return Environment.getExternalFilesDir(null).getAbsolutePath(); // Under construction - error cannot find symbol
    }




    public static void openUrl(String fullUrl, String extension)
    {
        String mimetype = android.webkit.MimeTypeMap.getSingleton().getMimeTypeFromExtension(extension);
        mimetype = mimetype == null ? "" : mimetype;

        Intent i = new Intent(Intent.ACTION_VIEW);
        i.setDataAndType(Uri.parse(fullUrl), mimetype);
        m_instance.startActivity(i);
    }

}

