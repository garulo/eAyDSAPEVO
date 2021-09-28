
package com.ayd.servlet;

import com.ayd.dao.RutaProperties;
import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONException;
import org.json.JSONObject;

public class SolicitarCNA extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
       response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String niscarta = request.getParameter("niscarta");
        String emailcarta = request.getParameter("emailcarta");

        Properties oProperties = new Properties();
       RutaProperties rp = new RutaProperties();
        InputStream isArchivo = new FileInputStream(rp.getRuta());
        oProperties.load(isArchivo);
        String GENERARCARTA = oProperties.getProperty("GENERARCARTA");
        URL url = new URL(GENERARCARTA+ niscarta + "&email=" + emailcarta);
        System.out.println("url :: " + url);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Accept", "application/json");

        if (conn.getResponseCode() != 200) {
            response.sendRedirect("Cna.jsp?cartamsj=0");
            System.out.println("conn.getResponseCode() ::: " + conn.getResponseCode());

        } else {

            try {

                InputStream inputStream = conn.getInputStream();
                String json = new String();
                BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(inputStream), 1);
                String line;
                while ((line = bufferedReader.readLine()) != null) {
                    json = line;
                }
                inputStream.close();
                bufferedReader.close();
                //System.out.println("json ::: " + json);
                JSONObject jsonObj = new JSONObject(json);
                if (jsonObj.get("success").toString() == "true") {
                    System.out.println("success TRUE CNA:::::");
                    response.sendRedirect("Cna.jsp?cartamsj=1");
                } else {
                    System.out.println("success FALSE CNA:::::");
                    response.sendRedirect("Cna.jsp?cartamsj=0&cmsj=" + jsonObj.get("message").toString());

                }
            } catch (IOException ioe) {
                Logger.getLogger(Autenticacion.class.getName()).log(Level.SEVERE, null, ioe);
            } catch (JSONException ex) {
                Logger.getLogger(Autenticacion.class.getName()).log(Level.SEVERE, null, ex);
            }
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
