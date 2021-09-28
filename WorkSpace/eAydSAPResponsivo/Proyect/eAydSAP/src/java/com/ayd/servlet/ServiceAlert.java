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

public class ServiceAlert extends HttpServlet {

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

            response.setContentType("text/html;charset=UTF-8");
            String nisalert = request.getParameter("nisalert");
            //System.out.println("*************** Alertas ******** nisalert ::: " + nisalert);
            InputStream isArchivo = new FileInputStream((String) objSession.getAttribute("urlProperties"));
            Properties oProperties = new Properties();
            oProperties.load(isArchivo);
            String[] arrOfStr = nisalert.split("///");
            for (String a : arrOfStr) {
                if (!a.equals("")) {

                    //System.out.println(":::" + a);
                    String v_sec_rec = a.substring(0, 1);
                    //System.out.println("v_sec_rec :::" + v_sec_rec);
                    String v_nis_rad = a.substring(1, 10);
                    //System.out.println("v_nis_rad :::" + v_nis_rad);
                    String Email = request.getParameter("Email");
                    Email = Email.replace("@", "%40");
                    //System.out.println("Email: " + Email);

                    String correo = new String();
                    String domicilio = new String();
                    String correoSAP = new String();
                    String domicilioSAP = new String();

                    if (v_sec_rec.equalsIgnoreCase("0")) {
                        domicilio = "true";
                        correo = "false";
                        domicilioSAP = "1";
                        correoSAP = "0";
                    } else if (v_sec_rec.equalsIgnoreCase("1")) {
                        domicilio = "false";
                        correo = "true";
                        domicilioSAP = "0";
                        correoSAP = "1";
                    } else if (v_sec_rec.equalsIgnoreCase("2")) {
                        domicilio = "true";
                        correo = "true";
                        domicilioSAP = "1";
                        correoSAP = "1";
                    } else {
                        domicilio = "true";
                        correo = "true";
                        domicilioSAP = "1";
                        correoSAP = "1";
                    }

                    //Consumo de UPDENVIOCORREO
                    String UPDENVIOCORREO = oProperties.getProperty("UPDENVIOCORREO");
                    System.out.println(UPDENVIOCORREO);

                    URL urlpost = new URL(UPDENVIOCORREO);
                    HttpURLConnection condata = (HttpURLConnection) urlpost.openConnection();
                    condata.setRequestMethod("POST");
                    condata.setRequestProperty("Content-Type", "application/json; utf-8");
                    condata.setRequestProperty("Content-Length", "135");
                    condata.setDoOutput(true);
                    condata.setRequestProperty("Authorization", "Bearer " + token);
                    String jsonInputStringdata = "{\n"
                            + "  \"Contrato\": \"" + v_nis_rad + "\",\n"
                            + "  \"EnvioCorreo\": \"" + correo + "\",\n"
                            + "  \"EnvioDomicilio\": \"" + domicilio + "\"\n"
                            + "}";
                   System.out.println("jsonInputStringdata alert servicio ::: " + jsonInputStringdata);

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
                        System.out.println("jsondata servicio alert UPDENVIOCORREO::: " + jsondata);
                        inputStreamdata.close();
                        bufferedReaderdata.close();
                        JSONObject jsonObjdata = new JSONObject(jsondata);

                        if (jsonObjdata.get("success").toString() == "true") {
                            String msg = jsonObjdata.get("message").toString();

                            System.out.println("success service alert UPDENVIOCORREO TRUE msg :::::"+v_nis_rad+" / " + msg);

                        } else {
                            String msg = jsonObjdata.get("message").toString();
                            System.out.println("success service alert UPDENVIOCORREO FALSE:::::"+v_nis_rad+" / " + msg);

                        }
                    } catch (JSONException ex) {
                        System.out.println("Error en servicio UPDENVIOCORREO FALSE:::::" + ex);
                        Logger.getLogger(RegistrarCuenta.class.getName()).log(Level.SEVERE, null, ex);
                    }

                    //Consumo de VIASENVIOSFACTURAS_SAP
                    String VIASENVIOSFACTURAS_SAP = oProperties.getProperty("VIASENVIOSFACTURAS_SAP");
                    URL urlpostsap = new URL(VIASENVIOSFACTURAS_SAP + v_nis_rad + "&envadom=" + domicilioSAP + "&envpcorreo="+correoSAP+"&email=" +  usuario + "");
                    System.out.println(urlpostsap);
                     HttpURLConnection condatasap = (HttpURLConnection) urlpostsap.openConnection();
                    condatasap.setRequestMethod("POST");
                    condatasap.setRequestProperty("Content-Type", "application/json; utf-8");
                    condatasap.setRequestProperty("Content-Length", "135");
                    condatasap.setDoOutput(true);
                    condatasap.setRequestProperty("Authorization", "Bearer " + token);
                    String jsonInputStringdatasap = "{\n"
                            + "  \"contrato\": \"" + v_nis_rad + "\",\n"
                            + "  \"envadom\": \"" + domicilioSAP + "\",\n"
                            + "  \"envpcorreo\": \"" + correoSAP + "\"\n"
                            + "  \"email\": \"" + usuario + "\"\n"
                            + "}";
                    System.out.println("jsonInputStringdata alert servicio VIASENVIOSFACTURAS_SAP ::: " + jsonInputStringdatasap);
                    
                     try (OutputStream ossap = condatasap.getOutputStream()) {
                        byte[] inputsap = jsonInputStringdatasap.getBytes("utf-8");
                        ossap.write(inputsap, 0, inputsap.length);
                    }
                    try (BufferedReader bdatasap = new BufferedReader(
                            new InputStreamReader(condatasap.getInputStream(), "utf-8"))) {
                        String jsondatasap = new String();
                        InputStream inputStreamdatasap = condatasap.getInputStream();
                        BufferedReader bufferedReaderdatasap = new BufferedReader(new InputStreamReader(inputStreamdatasap), 1);
                        String lineuserdatasap;
                        while ((lineuserdatasap = bufferedReaderdatasap.readLine()) != null) {
                            jsondatasap = lineuserdatasap;
                        }
                       System.out.println("jsondata servicio alert VIASENVIOSFACTURAS_SAP::: "+v_nis_rad+" / " + jsondatasap);
                        inputStreamdatasap.close();
                        bufferedReaderdatasap.close();
                        JSONObject jsonObjdatasap = new JSONObject(jsondatasap);

                        if (jsonObjdatasap.get("success").toString() == "true") {
                            String msgsap = jsonObjdatasap.get("message").toString();

                            System.out.println("success service alert VIASENVIOSFACTURAS_SAP TRUE msg :::::"+v_nis_rad+" / " + msgsap);

                        } else {
                            String msgsap = jsonObjdatasap.get("message").toString();
                            System.out.println("success service alert VIASENVIOSFACTURAS_SAP FALSE:::::"+v_nis_rad+" / " + msgsap);

                        }
                    } catch (JSONException ex) {
                        System.out.println("Error en servicio VIASENVIOSFACTURAS_SAP FALSE:::::" + ex);
                       
                    }
                    

                } else {
                    System.out.println(usuario+" SERVICIO DE ALERTAS no tiene contratos seleccionados para modificar");
                    response.sendRedirect("ServiciosAlertas.jsp");
                }
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
