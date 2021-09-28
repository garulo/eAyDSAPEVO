
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
import java.util.Date;
import java.util.Properties;
import java.util.UUID;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.json.JSONException;
import org.json.JSONObject;

public class PagarServiciosQB extends HttpServlet {

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
            response.setContentType("text/html;charset=UTF-8");
             Properties oProperties = new Properties();
            String nispagar = request.getParameter("nispagar");
            objSession.setAttribute("nispagar", nispagar);
            String nispagardt = request.getParameter("nispagardt");
            objSession.setAttribute("nispagardt", nispagardt);
            String montopagar = request.getParameter("montopagar");
            UUID uuid = UUID.randomUUID();

            int number = (int) (9999 * Math.random());
            String finalNumber = "" + number;
            for (int i = finalNumber.length(); i < 4; i++) {
                finalNumber = "0" + finalNumber;
            }
            
            int suf = (int) (9999 * Math.random());
            String sufijo = "" + suf;
            for (int i = sufijo.length(); i < 4; i++) {
                sufijo = "0" + sufijo;
            }

            String transactionId = uuid.toString() + finalNumber;
            objSession.setAttribute("transactionId", transactionId);
            String vpc_MerchTxnRef = "EAF"+transactionId;
            objSession.setAttribute("vpc_MerchTxnRef", vpc_MerchTxnRef);
            
            //TODO  
            //_-->notif 
            String[] listNisPagar = nispagardt.split("nis");
            double montoX99 = 0;
            for (String n : listNisPagar) {
                System.out.println("contrato: "+n);
                 montoX99 = montoX99 + Double.parseDouble( n.substring(32, n.length()));
                 Date objDate = new Date(); 
    //System.out.println("objDate " +objDate.toString());
                oProperties.load(isArchivo);
                String INSERTPAGOAPPSQLLOG = oProperties.getProperty("INSERTPAGOAPPSQLLOG");
                URL urlinsertarPagoLog = new URL(INSERTPAGOAPPSQLLOG);
                System.out.println("urlinsertarPagoLog :: "+urlinsertarPagoLog);
                HttpURLConnection coninsertarPagoLog = (HttpURLConnection) urlinsertarPagoLog.openConnection();
                coninsertarPagoLog.setRequestMethod("POST");
                coninsertarPagoLog.setRequestProperty("Content-Type", "application/json; utf-8");
                coninsertarPagoLog.setDoOutput(true);
                coninsertarPagoLog.setRequestProperty("Authorization", "Bearer " + token);

                String jsonInputString = "{\n"
                        + "  \"P_email\": \"" + usuario + "\",\n"
                        + "  \"P_monto\": \"" + n.substring(32, n.length()) + "\",\n" 
                        + "  \"P_nis_rad\": \"" + n.substring(0, 9) + "\",\n"
                        + "  \"P_referencia\": \"" + vpc_MerchTxnRef + "\",\n"
                        + "  \"P_mensaje\": \"-\",\n"
                        + "  \"P_fecha_fact\": \"" + n.substring(10, 20) + "\",\n"
                        + "  \"P_fecha_vcto\": \"" + n.substring(10, 20) + "\"\n"
                        + "}";
                System.out.println("jsonInputStringINSERTPAGOAPPSQLLOG ::: " + jsonInputString);
                
                try (OutputStream os = coninsertarPagoLog.getOutputStream()) {
                    byte[] input = jsonInputString.getBytes("utf-8");
                    os.write(input, 0, input.length);
                }

                try (BufferedReader bdata = new BufferedReader(
                        new InputStreamReader(coninsertarPagoLog.getInputStream(), "utf-8"))) {
                    String jsondata = new String();
                    InputStream inputStreamdata = coninsertarPagoLog.getInputStream();
                    BufferedReader bufferedReaderdata = new BufferedReader(new InputStreamReader(inputStreamdata), 1);
                    String lineuserdata;
                    while ((lineuserdata = bufferedReaderdata.readLine()) != null) {
                        jsondata = lineuserdata;
                    }
                    System.out.println("jsondata INSERTPAGOAPPSQLLOG::: "+objDate+" / " + jsondata);
                    inputStreamdata.close();
                    bufferedReaderdata.close();
                    JSONObject jsonObjdata = new JSONObject(jsondata);

                    if (jsonObjdata.get("success").toString() == "true") {
                        String msg = jsonObjdata.get("message").toString();
                        msg = msg.replace("Ã±", "ñ");
                        System.out.println("success service INSERTPAGOAPPSQLLOG TRUE::::: "+objDate+" / "+ n.substring(0, 9)+" / "+msg);
                       

                    } else {
                        String msg = jsonObjdata.get("message").toString();
                        msg = msg.replace("Ã±", "ñ");
                        System.out.println("success service INSERTPAGOAPPSQLLOG FALSE:::::"+objDate+" / "+n.substring(0, 9)+" / "+msg);
                        response.sendRedirect("sweetAlertError500.html");

                    }
                } catch (JSONException ex) {
                    System.out.println("success service INSERTPAGOAPPSQLLOG ERROR::::: "+objDate+" / "+n.substring(0, 9)+" / "+ ex);
                     response.sendRedirect("sweetAlertError500.html");
                }
                
                
            }
            System.out.println("montoX99 :: "+montoX99);
            objSession.setAttribute("montopagar", montoX99 + "");
             response.sendRedirect("QBController.jsp");
//             response.sendRedirect("EVOController.jsp");

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
