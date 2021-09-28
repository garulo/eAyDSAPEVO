
package com.ayd.servlet;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
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
import javax.servlet.http.HttpSession;
import org.json.JSONException;
import org.json.JSONObject;

public class RegistrarServicio extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
   PrintWriter out = response.getWriter();
        HttpSession objSession = request.getSession(false);
        String usuario = (String) objSession.getAttribute("usuario");
        String token = (String) objSession.getAttribute("token");
        if (null == usuario) {
            System.out.println("success HttpSession FALSE:::::");
            out.println("<script type=\"text/javascript\">");
        out.println("window.parent.location.href='sweetAlert.html'");
        out.println("</script>");
        } else if (usuario.equals("")) {
            System.out.println("success HttpSession FALSE:::::");
            out.println("<script type=\"text/javascript\">");
        out.println("window.parent.location.href='sweetAlert.html'");
        out.println("</script>");
        } else {
        InputStream isArchivo = new FileInputStream((String) objSession.getAttribute("urlProperties"));
        Properties oProperties = new Properties();
        oProperties.load(isArchivo);
        response.setContentType("text/html;charset=UTF-8");

        String nir = request.getParameter("NIR1");
       System.out.println("nir :: " + nir);
        String v_lect = request.getParameter("lecturaAnterior");
        //System.out.println("v_lect :: " + v_lect);
        String email = request.getParameter("email");
        email = email.replace("@", "%40");
        //System.out.println("email :: " + email);
        //System.out.println("token :: " + token);
        System.out.println("registrar contrato :: " + nir);
        String UPDSERVICIO = oProperties.getProperty("UPDSERVICIO");
        //System.out.println(UPDSERVICIO + v_sec_rec + "&v_nis_rad=" + v_nis_rad + "&v_sec_nis=" + v_sec_nis + "&v_f_fact=" + v_f_fact + "&Email=" + email + "&v_lect=" + v_lect + "&notificacion=" + notificacion + "&v_ab=" + v_ab + "");
        //URL urlpost = new URL(UPDSERVICIO + v_sec_rec + "&v_nis_rad=" + v_nis_rad + "&v_sec_nis=" + v_sec_nis + "&v_f_fact=" + v_f_fact + "&Email=" + email + "&v_lect=" + v_lect + "&notificacion=" + notificacion + "&v_ab=" + v_ab + "");
        URL urlpost = new URL(UPDSERVICIO+nir+"&correo="+email);
        HttpURLConnection condata = (HttpURLConnection) urlpost.openConnection();
        condata.setRequestMethod("POST");
        condata.setRequestProperty("Content-Type", "application/json; utf-8");
        condata.setRequestProperty("Content-Length", "135");
        condata.setDoOutput(true);
        condata.setRequestProperty("Authorization", "Bearer " + token);
        String jsonInputStringdata = "{\n"
                + "  \"contrato\": \"" + nir + "\",\n"
                + "  \"correo\": \"" + email + "\"\n"
                + "}";
        //System.out.println("jsonInputStringdata registrar servicio ::: "+jsonInputStringdata);
        try (OutputStream os = condata.getOutputStream()) {
            byte[] input = jsonInputStringdata.getBytes("utf-8");
            os.write(input, 0, input.length);
        }
        try (BufferedReader bdata = new BufferedReader(
                new InputStreamReader(condata.getInputStream(), "utf-8"))) {
            String jsondata = new String();
            InputStream inputStreamdata = condata.getInputStream();
            BufferedReader bufferedReaderdata = new BufferedReader(new InputStreamReader(inputStreamdata), 1);
            String lineuserdata;
            while ((lineuserdata = bufferedReaderdata.readLine()) != null) {
                jsondata = lineuserdata;
            }
            System.out.println("jsondata servicio registrar::: " + jsondata);
            inputStreamdata.close();
            bufferedReaderdata.close();
            JSONObject jsonObjdata = new JSONObject(jsondata);
//            System.out.println("jsonObjdata.get(\"success\").toString(): "+jsonObjdata.get("success").toString());
            String jsonResponse = jsonObjdata.get("Response").toString(); 
            //System.out.println("jsonResponse : "+jsonResponse);
            
            jsonResponse = jsonResponse.replace("{\"data\":", "");
            jsonResponse =jsonResponse.substring(0,jsonResponse.length()-1);
            JSONObject jsonObjdatas = new JSONObject(jsonResponse);
            String CodRetorno = jsonObjdatas.get("EstatusSQl").toString(); 
            String Mensaje = jsonObjdatas.get("Mensaje").toString(); 
             System.out.println("jsonResponse : "+jsonResponse);
            if (CodRetorno.equalsIgnoreCase("true")) {
                //String msg = jsonObjdata.get("message").toString();
                //msg = msg.replace("Ã±", "ñ");
                System.out.println("success service registrar TRUE:::::");
                out.println("<script type=\"text/javascript\">");
                 out.println("location='sweetAlertRegisServtrue.html?men="+Mensaje+"'");
                out.println("</script>");

            } else {
                System.out.println("success service registrar FALSE:::::");
                out.println("<script type=\"text/javascript\">");
                 out.println("location='sweetAlertRegisServfalse.html?men="+Mensaje+"'");
                out.println("</script>");
            }
        } catch (JSONException ex) {
            Logger.getLogger(RegistrarServicio.class.getName()).log(Level.SEVERE, null, ex);
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
