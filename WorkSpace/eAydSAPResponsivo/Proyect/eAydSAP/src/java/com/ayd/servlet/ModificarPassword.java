
package com.ayd.servlet;

import com.ayd.dao.RutaProperties;
import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.security.MessageDigest;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONException;
import org.json.JSONObject;

public class ModificarPassword extends HttpServlet {

     public static String sha256(String base) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(base.getBytes("UTF-8"));
            StringBuffer hexString = new StringBuffer();
            for (int i = 0; i < hash.length; i++) {
                String hex = Integer.toHexString(0xff & hash[i]);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (Exception ex) {
            throw new RuntimeException(ex);
        }
    }
  
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
         response.setContentType("text/html;charset=UTF-8");

        PrintWriter out = response.getWriter();

        String passwordactual = request.getParameter("passwordactual");
        passwordactual = sha256(passwordactual);
        String password = request.getParameter("password");
        password = sha256(password);
        String email = request.getParameter("email");
        String token = request.getParameter("token");

        Properties oProperties = new Properties();
        RutaProperties rp = new RutaProperties();
        InputStream isArchivo = new FileInputStream(rp.getRuta());
        oProperties.load(isArchivo);
        String PSTACTUALIZAPASSWORD = oProperties.getProperty("PSTACTUALIZAPASSWORD");
        String INICIO = oProperties.getProperty("INICIO");
        URL urlpost = new URL(PSTACTUALIZAPASSWORD + email + "&PasswordActual=" + passwordactual + "&NuevoPassword=" + password + "");
        HttpURLConnection conuserdata = (HttpURLConnection) urlpost.openConnection();
        conuserdata.setRequestMethod("POST");
        conuserdata.setRequestProperty("Content-Type", "application/json; utf-8");
        conuserdata.setDoOutput(true);
        conuserdata.setRequestProperty("Authorization", "Bearer " + token);
        String jsonInputStringuserdata = "{\n"
                + "  \"Email\": \"" + email + "\",\n"
                + "  \"PasswordActual\": \"" + passwordactual + "\",\n"
                + "  \"NuevoPassword\": \"" + password + "\"\n"
                + "}";
        try (OutputStream os = conuserdata.getOutputStream()) {
            byte[] input = jsonInputStringuserdata.getBytes("utf-8");
            os.write(input, 0, input.length);
        }
        System.out.println("::: jsonInputStringuserdatapassword:::" + jsonInputStringuserdata);
        try (BufferedReader bruserdata = new BufferedReader(
                new InputStreamReader(conuserdata.getInputStream(), "utf-8"))) {
            String jsonuserdata = new String();
            InputStream inputStreamuserdata = conuserdata.getInputStream();
            BufferedReader bufferedReaderuserdata = new BufferedReader(new InputStreamReader(inputStreamuserdata), 1);
            String lineuserdata;
            while ((lineuserdata = bufferedReaderuserdata.readLine()) != null) {
                jsonuserdata = lineuserdata;
            }
            System.out.println("jsonuserdata ::: " + jsonuserdata);
            inputStreamuserdata.close();
            bufferedReaderuserdata.close();
            JSONObject jsonObjuserdata = new JSONObject(jsonuserdata);
            if (jsonObjuserdata.get("success").toString() == "true") {
                System.out.println("success userdatapass True:::::");
                String msg = jsonObjuserdata.get("message").toString();
                msg = msg.replace("Ã±", "ñ");
                System.out.println("success TRUE:::::");
                out.println("<script type=\"text/javascript\">");
                out.println("location='sweetAlertModifPasstrue.html'");
                out.println("</script>");

            } else {
                String msg = jsonObjuserdata.get("message").toString();
                msg = msg.replace("Ã±", "ñ");
                System.out.println("success FALSE:::::");
                out.println("<script type=\"text/javascript\">");
                out.println("location='sweetAlertModifPasstrue.html'");
                out.println("</script>");

            }
        } catch (JSONException ex) {
            System.out.println("EXCEPTION EN PSTACTUALIZAPASSWORD : "+ex);
            response.sendRedirect(INICIO);
           
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
