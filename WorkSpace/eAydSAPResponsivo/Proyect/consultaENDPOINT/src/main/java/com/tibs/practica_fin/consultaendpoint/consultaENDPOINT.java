
package com.tibs.practica_fin.consultaendpoint;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Date;

public class consultaENDPOINT {
    
    private static final String USER_AGENT = "Mozilla/5.0";

    private static final String GET_URL = "https://transfer.qbitspay.com/payment-client/v1/status/6992e531-3181-494b-9bc3-cfa8258ca3de2245";
    
    
    public static void main(String[] args){
    
        for(int x =0 ; x< 10000; x++){
        
           
                new Thread(new Runnable() {

                    @Override
                    public void run() {
                         try{
                consultaENDPOINT.sendGET();
            }catch(Exception e){
            }
                    }
                }).start();
        
        
        }
    }
    
    private static void sendGET() throws IOException {
        Date d = new Date();
		URL obj = new URL(GET_URL);
		      HttpURLConnection con = (HttpURLConnection) obj.openConnection();
		con.setRequestMethod("GET");
		con.setRequestProperty("User-Agent", USER_AGENT);
		int responseCode = con.getResponseCode();
		System.out.println(d+" GET Response Code :: " + responseCode);
		if (responseCode == HttpURLConnection.HTTP_OK) { // success
			                 BufferedReader in = new BufferedReader(new InputStreamReader(
					con.getInputStream()));
			String inputLine;
			StringBuffer response = new StringBuffer();

			while ((inputLine = in.readLine()) != null) {
				response.append(inputLine);
			}
			in.close();

			// print result
			System.out.println(response.toString());
		} else {
			System.out.println("GET request not worked");
		}

	}
    
}
