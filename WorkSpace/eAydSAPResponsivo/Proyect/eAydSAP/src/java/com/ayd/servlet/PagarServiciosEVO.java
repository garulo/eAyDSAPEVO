package com.ayd.servlet;

import com.ayd.beans.eAydObj;
import com.ayd.dao.ServicioNISDAO;
import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.Base64;
import java.util.Date;
import java.util.Properties;
import java.util.UUID;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class PagarServiciosEVO extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        PrintWriter out = response.getWriter();
        HttpSession objSession = request.getSession(false);
        String usuario = (String) objSession.getAttribute("usuario");
        System.out.println("usuario: " + usuario);
        String token = (String) objSession.getAttribute("token");
        Date objDate = new Date();
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
            String jsonObjcreasesionevoresponsedatamerchant = new String();
            String jsonObjcreasesionevoresponsedatasessionid = new String();
            InputStream isArchivo = new FileInputStream((String) objSession.getAttribute("urlProperties"));
            Date fechaactual = new Date();
            response.setContentType("text/html;charset=UTF-8");
            Properties oProperties = new Properties();
            oProperties.load(isArchivo);
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
            String vpc_MerchTxnRef = "EAF" + transactionId;
            objSession.setAttribute("vpc_MerchTxnRef", vpc_MerchTxnRef);

            String[] listNisPagar = nispagardt.split("nis");
            ArrayList<ServicioNISDAO> lstServ = new ArrayList();

            String SELSALDOS = oProperties.getProperty("SELSALDOS");
            System.out.println("SELSALDOS: " + SELSALDOS);
            URL urlsaldos = new URL(SELSALDOS + usuario);
            System.out.println("url saldos:: " + urlsaldos.toString());

            HttpURLConnection connsaldos = (HttpURLConnection) urlsaldos.openConnection();
            connsaldos.setRequestMethod("GET");
            connsaldos.setRequestProperty("Accept", "application/json");
            connsaldos.setRequestProperty("Authorization", "Bearer " + objSession.getAttribute("token"));

            if (connsaldos.getResponseCode() != 200) {

                System.out.println(SELSALDOS + " ::SELSALDOS No posible recalcular el saldo response code: " + fechaactual + " / " + connsaldos.getResponseCode());
//                           
                response.sendRedirect("sweetAlertError500.html");
//                        throw new RuntimeException("Failed : HTTP error code : " + connsaldos.getResponseCode());

            } else {
                double montoX99 = 0;
                System.out.println("::SELSALDOS RecalcularSaldos :: " + fechaactual + " / ");
                try {

                    InputStream inputStreamsaldos = connsaldos.getInputStream();
                    String jsonsaldos = new String();
                    BufferedReader bufferedReadersaldos = new BufferedReader(new InputStreamReader(inputStreamsaldos), 1);
                    String linesaldos = "";
                    while ((linesaldos = bufferedReadersaldos.readLine()) != null) {
                        jsonsaldos = linesaldos;
                    }
                    inputStreamsaldos.close();
                    bufferedReadersaldos.close();
                    System.out.println("jsonsaldos recalcular ::: " + jsonsaldos);
                    JSONObject jsonObjsaldos = new JSONObject(jsonsaldos);

                    JSONObject jsonObjservresponse = new JSONObject(jsonObjsaldos.get("Response").toString());
                    // System.out.println("strjsonObjservresponsedata :: " +jsonObjservresponse.toString());
                    String strjsonObjservresponsedata = jsonObjservresponse.get("data").toString();

                    strjsonObjservresponsedata = strjsonObjservresponsedata.replace("[", "");
                    strjsonObjservresponsedata = strjsonObjservresponsedata.replace("]", "");

                    //System.out.println("strjsonObjservresponsedata :: " + strjsonObjservresponsedata);
                    JSONObject jsonObjservresponsedata = new JSONObject(strjsonObjservresponsedata);
                    System.out.println("jsonObjservresponsedata recalcular saldos :: " + jsonObjservresponsedata.toString());

                    JSONArray results = new JSONArray(jsonObjservresponse.get("data").toString());
                    // System.out.println("result:: " + results.length());
                    for (int i = 0; i < results.length(); i++) {
                        JSONObject aux = results.getJSONObject(i);
                        ServicioNISDAO serv = new ServicioNISDAO();
                        serv.setV_nis_rad(aux.get("NIS").toString());
                        serv.setV_sec_rec("0");
                        serv.setV_f_fact(aux.get("Fecha_Venc").toString());
                        serv.setV_sec_nis(aux.get("Fecha_Venc").toString());
                        serv.setV_f_vcto(aux.get("Fecha_Venc").toString());
                        serv.setV_importe(Double.parseDouble(aux.get("v_totaladeu").toString()));
                        String strDomicilio = "" + aux.get("Direccion").toString() + " ";
                        String strdomicilioLegible = new String(strDomicilio.getBytes("ISO-8859-1"), "UTF-8");
                        serv.setP_Direccion(strdomicilioLegible);
                        serv.setPartner(aux.get("Partner").toString());
                        serv.setVkont(aux.get("Vkont").toString());
                        lstServ.add(serv);
                    }
                    connsaldos.disconnect();
                } catch (IOException ioe) {
                    System.out.println(transactionId + " IOException selsaldos recalcular ::: " + ioe);
                } catch (JSONException ex) {
                    System.out.println(transactionId + " JSONException selsaldos recalcular ::: " + ex);
                }

                double amountcalc = 0;
                for (String n : listNisPagar) {
                    System.out.println("n.substring(0, 9) nis: " + n.substring(0, 9));
                    for (ServicioNISDAO sn : lstServ) {
                        if (n.substring(0, 9).equalsIgnoreCase(sn.getV_nis_rad())) {

                            amountcalc = amountcalc + sn.getV_importe();

                        }
                    }
                }
                String abc1 = String.valueOf(amountcalc);
                String abc = String.valueOf(amountcalc);
                abc = abc.replace(".", "");
                amountcalc = Double.parseDouble(abc) / 100;
                System.out.println("::::::::: amountcalc: " + amountcalc);
                Long lon = Long.parseLong(abc) / 100;
//                System.out.println("::::::::: lon: " + lon);
                String finalamountcalc = "" + lon;

                System.out.println("El amountcalc recalculado y formateado " + fechaactual + " / " + transactionId + "/" + finalamountcalc);

                //MONTO RECALCULDO POR CONTRATOS SELECCIONADOS
                objSession.setAttribute("finalamountcalc", finalamountcalc);

                final String CREASESIONEVO = oProperties.getProperty("CREASESIONEVO");
                URL urlcreasesionevo = new URL(CREASESIONEVO);
                System.out.println("urlcreasesionevo :: " + urlcreasesionevo);
                HttpURLConnection concreasesionevo = (HttpURLConnection) urlcreasesionevo.openConnection();
                concreasesionevo.setRequestMethod("POST");
                concreasesionevo.setRequestProperty("Content-Type", "application/json; utf-8");
                concreasesionevo.setDoOutput(true);
                concreasesionevo.setRequestProperty("Authorization", "Bearer " + token);
                
                String uuid12=UUID.randomUUID().toString();
                uuid12 = uuid12.replace("-", "");
                uuid12 = uuid12.substring(0,12);
                String IDMessageHeader = "PAY-"+uuid12;//(Pay +UUID(12))";
                objSession.setAttribute("IDMessageHeader", IDMessageHeader);
                       
                
                
                String jsonInputStringcreasesionevo = "{\n"
                        + "  \"monto\": \"" + abc1 + "\",\n"
                        + "  \"plataforma\": \"W\",\n"
                        + "  \"IDMessageHeader\": \"" + IDMessageHeader + "\"\n"
                        + "}";
                System.out.println("jsonInputStringCREASESIONEVO ::: " + jsonInputStringcreasesionevo);

                try (OutputStream osconcreasesionevo = concreasesionevo.getOutputStream()) {
                    byte[] inputcreasesionevo = jsonInputStringcreasesionevo.getBytes("utf-8");
                    osconcreasesionevo.write(inputcreasesionevo, 0, inputcreasesionevo.length);
                }

                try (BufferedReader bdataconcreasesionevo = new BufferedReader(
                        new InputStreamReader(concreasesionevo.getInputStream(), "utf-8"))) {
                    String jsondataconcreasesionevo = new String();
                    InputStream inputStreamdatacreasesionevo = concreasesionevo.getInputStream();
                    BufferedReader bufferedReaderdatacreasesionevo = new BufferedReader(new InputStreamReader(inputStreamdatacreasesionevo), 1);
                    String lineuserdatacreasesionevo;
                    while ((lineuserdatacreasesionevo = bufferedReaderdatacreasesionevo.readLine()) != null) {
                        jsondataconcreasesionevo = lineuserdatacreasesionevo;
                    }
                    System.out.println("jsondata CREASESIONEVO::: " + objDate + " / " + jsondataconcreasesionevo);
                    inputStreamdatacreasesionevo.close();
                    bufferedReaderdatacreasesionevo.close();
                    JSONObject jsonObjdatacreasesionevo = new JSONObject(jsondataconcreasesionevo);

                    if (jsonObjdatacreasesionevo.get("success").toString() == "true") {
                        String msg = jsonObjdatacreasesionevo.get("message").toString();
                        msg = msg.replace("Ã±", "ñ");
                        System.out.println("success service CREASESIONEVO TRUE::::: " + objDate + " / " + msg + " / " + msg);
                        if ("null" != jsonObjdatacreasesionevo.get("Response").toString()) {
                            JSONObject jsonObjcreasesionevoresponse = new JSONObject(jsonObjdatacreasesionevo.get("Response").toString());
                            JSONObject jsonObjcreasesionevoresponsedata = new JSONObject(jsonObjcreasesionevoresponse.get("data").toString());
                            String jsonObjcreasesionevoresponseref = jsonObjcreasesionevoresponsedata.get("REF").toString();
                            jsonObjcreasesionevoresponseref = jsonObjcreasesionevoresponseref.replaceAll("REF", "");


                             String jsonObjcreasesionevoresponseidReferece = jsonObjcreasesionevoresponsedata.get("idReference").toString();
                            System.out.println("jsonObjcreasesionevoresponseidReferece :: " + jsonObjcreasesionevoresponseidReferece);
                            objSession.setAttribute("idReferece", jsonObjcreasesionevoresponseidReferece);
                            for (String n : listNisPagar) {
                                System.out.println("n.substring(0, 9) nis: " + n.substring(0, 9));
                                for (ServicioNISDAO sn : lstServ) {
                                    if (n.substring(0, 9).equalsIgnoreCase(sn.getV_nis_rad())) {

                                        amountcalc = amountcalc + sn.getV_importe();
                                        String INSERTPAGOAPPSQLLOG = oProperties.getProperty("INSERTPAGOAPPSQLLOG");
                                        URL urlinsertarPagoLog = new URL(INSERTPAGOAPPSQLLOG);
                                        System.out.println("urlinsertarPagoLog :: " + urlinsertarPagoLog);
                                        HttpURLConnection coninsertarPagoLog = (HttpURLConnection) urlinsertarPagoLog.openConnection();
                                        coninsertarPagoLog.setRequestMethod("POST");
                                        coninsertarPagoLog.setRequestProperty("Content-Type", "application/json; utf-8");
                                        coninsertarPagoLog.setDoOutput(true);
                                        coninsertarPagoLog.setRequestProperty("Authorization", "Bearer " + token);

                                        String jsonInputString = "{\n"
                                                + "  \"P_email\": \"" + usuario + "\",\n"
                                                + "  \"P_monto\": \"" + sn.getV_importe() + "\",\n"
                                                + "  \"P_nis_rad\": \"" + sn.getV_nis_rad() + "\",\n"
                                                + "  \"P_referencia\": \"" + jsonObjcreasesionevoresponseidReferece + "\",\n"
                                                + "  \"P_mensaje\": \"-\",\n"
                                                + "  \"P_fecha_fact\": \"" + sn.getV_f_fact() + "\",\n"
                                                + "  \"P_fecha_vcto\": \"" + sn.getV_f_vcto() + "\",\n"
                                                 + "  \"InterlocutorComercial\": \"" + sn.getPartner()+ "\",\n"
                                                + "  \"CuentaContrato\": \"" + sn.getVkont()+ "\"\n"
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
                                            System.out.println("jsondata INSERTPAGOAPPSQLLOG::: " + objDate + " / " + jsondata);
                                            inputStreamdata.close();
                                            bufferedReaderdata.close();
                                            JSONObject jsonObjdata = new JSONObject(jsondata);

                                            if (jsonObjdata.get("success").toString() == "true") {
                                                String msg1 = jsonObjdata.get("message").toString();
                                                msg1 = msg1.replace("Ã±", "ñ");
                                                System.out.println("success service INSERTPAGOAPPSQLLOG TRUE::::: " + objDate + " / " + n.substring(0, 9) + " / " + msg1);

                                            } else {
                                                String msg1 = jsonObjdata.get("message").toString();
                                                msg1 = msg1.replace("Ã±", "ñ");
                                                System.out.println("success service INSERTPAGOAPPSQLLOG FALSE:::::" + objDate + " / " + n.substring(0, 9) + " / " + msg1);
                                                response.sendRedirect("sweetAlertError500.html");

                                            }
                                        } catch (JSONException ex) {
                                            System.out.println("success service INSERTPAGOAPPSQLLOG ERROR::::: " + objDate + " / " + n.substring(0, 9) + " / " + ex);
                                            response.sendRedirect("sweetAlertError500.html");
                                        }

                                    }
                                }
                            }

                            String jsonObjcreasesionevoresponsesessionsuccessIndicator = jsonObjcreasesionevoresponsedata.get("SuccessIndicator").toString();
                            System.out.println("successIndicator :  " + jsonObjcreasesionevoresponsesessionsuccessIndicator);
                            objSession.setAttribute("successIndicator", jsonObjcreasesionevoresponsesessionsuccessIndicator);
                            
                            System.out.println("jsonObjcreasesionevoresponseref :  " + jsonObjcreasesionevoresponseref);
                            String respuesta = "error";
                            try {
                                respuesta = new String(Base64.getDecoder().decode(jsonObjcreasesionevoresponseref.getBytes("UTF8")), "UTF-8");
                            } catch (UnsupportedEncodingException e) {
                                e.printStackTrace();
                            }
                            byte[] bytesDecodificadosref = Base64.getDecoder().decode(jsonObjcreasesionevoresponseref);
                            String cadenaDecodificadaref = new String(bytesDecodificadosref);

                            //System.out.println("decodificado: " + cadenaDecodificadaref);
                            System.out.println("HTML REF64 :  " + respuesta);
                            out.println(cadenaDecodificadaref);

                        }

                    } else {
                        String msg = jsonObjdatacreasesionevo.get("message").toString();
                        msg = msg.replace("Ã±", "ñ");
                        System.out.println("success service CREASESIONEVO FALSE:::::" + objDate + " / " + msg + " / " + msg);
                        response.sendRedirect("sweetAlertError500.html");

                    }
                } catch (JSONException ex) {
                    System.out.println("success service CREASESIONEVO ERROR::::: " + objDate + " / " + ex + " / " + ex);
                    response.sendRedirect("sweetAlertError500.html");
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
