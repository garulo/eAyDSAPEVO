package com.ayd.servlet;

import com.ayd.dao.RutaProperties;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import org.json.JSONException;
import org.json.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

@MultipartConfig
public class GenerarReporteOperativo extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, ParseException, JSONException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        String Comentario = request.getParameter("Comentario");
        Comentario = new String(Comentario.getBytes("ISO-8859-1"), "UTF-8");
        System.out.println("Comentario: " + Comentario);
        String Sub_Cat = request.getParameter("Sub_Cat");
        System.out.println("Sub_Cat: " + Sub_Cat);
        String Contrato = request.getParameter("Contrato");
        Contrato = new String(Contrato.getBytes("ISO-8859-1"), "UTF-8");
        System.out.println("Contrato: " + Contrato);
        String Municipio = new String();
        String Colonia = new String();
        String Calle = new String();
        String Puerta = new String();

        if (Contrato.equalsIgnoreCase("00")) {
            System.out.println("00");
            Municipio = request.getParameter("Municipio");
            String[] arrMunicipio = Municipio.split("_");
            Municipio = arrMunicipio[1];
            Municipio = new String(Municipio.getBytes("ISO-8859-1"), "UTF-8");
            Municipio = Municipio.replace("/", " ");
            System.out.println("Municipio: " + Municipio);
            Colonia = request.getParameter("Colonia");
            String[] arrColonia = Colonia.split("_");
            Colonia = arrColonia[1];
            Colonia = new String(Colonia.getBytes("ISO-8859-1"), "UTF-8");
            Colonia = Colonia.replace("/", " ");
            System.out.println("Colonia: " + Colonia);
            Calle = request.getParameter("Calle");

            Calle = new String(Calle.getBytes("ISO-8859-1"), "UTF-8");
            Calle = Calle.replace("/", " ");
            System.out.println("Calle: " + Calle);
            Puerta = request.getParameter("Puerta");
            Puerta = new String(Puerta.getBytes("ISO-8859-1"), "UTF-8");
            System.out.println("Puerta: " + Puerta);
        } else {
            System.out.println("Split");
            Contrato = Contrato.replace(" | ", "-");
            String[] arrContrato = Contrato.split("-");
            System.out.println("arrContrato size: " + arrContrato.length);
            Contrato = arrContrato[0];
            System.out.println("Contrato: " + Contrato);
            Calle = arrContrato[1];
            System.out.println("Calle: " + Calle);
            Colonia = arrContrato[2];
            System.out.println("Colonia: " + Colonia);
            Municipio = arrContrato[3];
            System.out.println("Municipio: " + Municipio);
            Puerta = request.getParameter("Puerta");
            Puerta = new String(Puerta.getBytes("ISO-8859-1"), "UTF-8");
            System.out.println("Puerta: " + Puerta);
        }

        String Email = request.getParameter("Email");
        System.out.println("Email: " + Email);
        String Referencia = request.getParameter("Referencia");
        Referencia = new String(Referencia.getBytes("ISO-8859-1"), "UTF-8");
        System.out.println("Referencia: " + Referencia);
        String CP = request.getParameter("CP");
        System.out.println("CP: " + CP);

//        Part pic1 = request.getPart("pic1");
//        String fileNamepic1 = Paths.get(pic1.getSubmittedFileName()).toString();
//        InputStream fileContentpic1 = pic1.getInputStream();
//        System.out.println("fileNamepic1: " + request.getPart("pic1").toString());
//        System.out.println("fileContentpic1: " + fileContentpic1);
//        Part pic2 = request.getPart("pic2");
//        String fileNamepic2 = Paths.get(pic2.getName()).toString();
////        InputStream fileContentpic2 = pic2.getInputStream();
////        System.out.println("fileNamepic2: " + fileNamepic2);
////        System.out.println("fileContentpic2: " + fileContentpic2);
//        Part pic3 = request.getPart("pic3");
//        String fileNamepic3 = Paths.get(pic3.getSubmittedFileName()).toString();
////        InputStream fileContentpic3 = pic3.getInputStream();
////        System.out.println("fileNamepic3: " + fileNamepic3);
////        System.out.println("fileContentpic3: " + pic3);
//
//        Part pic4 = request.getPart("pic4");
//        String fileNamepic4 = Paths.get(pic4.getSubmittedFileName()).toString();

        //ORDENDESERVICIODIRECCIONSAP
        Properties oProperties = new Properties();
        RutaProperties rp = new RutaProperties();
        InputStream isArchivo = new FileInputStream(rp.getRuta());
        String token = request.getParameter("token");
//
        oProperties.load(isArchivo);
        String ORDENDESERVICIODIRECCIONSAP = oProperties.getProperty("ORDENDESERVICIODIRECCIONSAP");
        URL url = new URL(ORDENDESERVICIODIRECCIONSAP + Sub_Cat + "&Municipio=" + Municipio.replace(" ", "%20") + "&Colonia=" + Colonia.replace(" ", "%20") + "&Calle=" + Calle.replace(" ", "%20") + "&Puerta=" + Puerta.replace(" ", "%20") + "&Email=" + Email + "&Comentario=" + Comentario.replace(" ", "%20") + "");
        System.out.println("URL ORDENDESERVICIODIRECCIONSAP: " + url.toString());
        HttpURLConnection con = (HttpURLConnection) url.openConnection();
        con.setRequestMethod("POST");
        con.setRequestProperty("Content-Type", "application/json; utf-8");
        con.setDoOutput(true);
        String jsonInputString = "{\n"
                + "  \"Sub_Cat\": \"" + Sub_Cat + "\",\n"
                + "  \"Municipio\": \"" + Municipio + "\",\n"
                + "  \"Colonia\": \"" + Colonia + "\",\n"
                + "  \"Calle\": \"" + Calle + "\",\n"
                + "  \"Puerta\": \"" + Puerta + "\",\n"
                + "  \"Email\": \"" + Email + "\",\n"
                + "  \"Comentario\": \"" + Comentario + "\"\n"
                + "}";

        try (OutputStream os = con.getOutputStream()) {
            byte[] input = jsonInputString.getBytes("utf-8");
            os.write(input, 0, input.length);
        }
        try (BufferedReader br = new BufferedReader(
                new InputStreamReader(con.getInputStream(), "utf-8"))) {
            String json = new String();
            InputStream inputStream = con.getInputStream();
            BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(inputStream), 1);
            String line;
            while ((line = bufferedReader.readLine()) != null) {
                json = line;
            }
            System.out.println("jsonORDENDESERVICIODIRECCIONSAP response ::: " + json);
            inputStream.close();
            bufferedReader.close();
            JSONObject jsonObj = new JSONObject(json);
            JSONObject jsonObjordensapresponse = new JSONObject(jsonObj.get("Response").toString());
            JSONObject jsonObjordensapresponsedata = new JSONObject(jsonObjordensapresponse.get("data").toString());
            String folio = jsonObjordensapresponsedata.get("folio").toString();
            System.out.println("folio: " + folio);

            String CodReturn = jsonObjordensapresponsedata.get("CodReturn").toString();
            System.out.println("CodReturn: " + CodReturn);
            if (jsonObj.get("success").toString() == "true") {
                System.out.println("se genero el reporte operativo en SAP TRUE:::::");
                Date dat = new Date();
                String timeStamp = new SimpleDateFormat("HH:mm:ss").format(Calendar.getInstance().getTime());
                
                //POSTREPORTEOPERATIVOSQL
                String POSTREPORTEOPERATIVOSQL = oProperties.getProperty("POSTREPORTEOPERATIVOSQL");
                URL urlPOSTREPORTEOPERATIVOSQL = new URL(POSTREPORTEOPERATIVOSQL);
                System.out.println("URL urlPOSTREPORTEOPERATIVOSQL: " + urlPOSTREPORTEOPERATIVOSQL.toString());
                HttpURLConnection conPOSTREPORTEOPERATIVOSQL = (HttpURLConnection) urlPOSTREPORTEOPERATIVOSQL.openConnection();
                conPOSTREPORTEOPERATIVOSQL.setRequestMethod("POST");
                conPOSTREPORTEOPERATIVOSQL.setRequestProperty("Content-Type", "application/json; utf-8");
                conPOSTREPORTEOPERATIVOSQL.setDoOutput(true);
                conPOSTREPORTEOPERATIVOSQL.setRequestProperty("Authorization", "Bearer " + token);
                String jsonInputStringPOSTREPORTEOPERATIVOSQL = "{\n"
                        + "  \"Folio\": \"" + folio + "\",\n"
                        + "  \"Fecha_de_Registro\": \"" + dat + "\",\n"
                        + "  \"Hora_de_Registro\": \"" + timeStamp + "\",\n"
                        + "  \"Usuario_que_Registra\": \"0\",\n"
                        + "  \"Correo\": \"" + Email + "\",\n"
                        + "  \"Calle\": \"" + Calle + "\",\n"
                        + "  \"Numero\": \"" + Puerta + "\",\n"
                        + "  \"Colonia\": \"" + Colonia + "\",\n"
                        + "  \"Codigo_postal\": \"" + CP + "\",\n"
                        + "  \"Referencias\": \"" + Referencia + "\",\n"
                        + "  \"Comentarios_Adicionales\": \"" + Comentario + "\",\n"
                        + "  \"Latitud\": \"\",\n"
                        + "  \"Longitud\": \"\",\n"
                        + "  \"Fecha_que_se_atendio\": \"\",\n"
                        + "  \"Hora_que_se_atendio\": \"\",\n"
                        + "  \"Usuario_que_atendio\": \"\",\n"
                        + "  \"Estatus\": \"0\",\n"
                        + "  \"Comentarios\": \"" + Comentario + "\",\n"
                        + "  \"NumOS\": \"" + folio + "\",\n"
                        + "  \"TipoOS\": \"" + Sub_Cat + "\",\n"
                        + "  \"EstadoOS\": \"\",\n"
                        + "  \"Municipio\": \"" + Municipio + "\",\n"
                        + "  \"FlagCorreo\": \"0\"\n"
                        + "}";
                System.out.println("json request POSTREPORTEOPERATIVOSQL :: " + jsonInputStringPOSTREPORTEOPERATIVOSQL);
                try (OutputStream osPOSTREPORTEOPERATIVOSQL = conPOSTREPORTEOPERATIVOSQL.getOutputStream()) {
                    byte[] inputPOSTREPORTEOPERATIVOSQL = jsonInputStringPOSTREPORTEOPERATIVOSQL.getBytes("utf-8");
                    osPOSTREPORTEOPERATIVOSQL.write(inputPOSTREPORTEOPERATIVOSQL, 0, inputPOSTREPORTEOPERATIVOSQL.length);
                }
                try (BufferedReader brPOSTREPORTEOPERATIVOSQL = new BufferedReader(
                        new InputStreamReader(conPOSTREPORTEOPERATIVOSQL.getInputStream(), "utf-8"))) {
                    String jsonPOSTREPORTEOPERATIVOSQL = new String();
                    InputStream inputStreamPOSTREPORTEOPERATIVOSQL = conPOSTREPORTEOPERATIVOSQL.getInputStream();
                    BufferedReader bufferedReaderPOSTREPORTEOPERATIVOSQL = new BufferedReader(new InputStreamReader(inputStreamPOSTREPORTEOPERATIVOSQL), 1);
                    String linePOSTREPORTEOPERATIVOSQL;
                    while ((linePOSTREPORTEOPERATIVOSQL = bufferedReaderPOSTREPORTEOPERATIVOSQL.readLine()) != null) {
                        jsonPOSTREPORTEOPERATIVOSQL = linePOSTREPORTEOPERATIVOSQL;
                    }
                    System.out.println("jsonPOSTREPORTEOPERATIVOSQL response ::: " + jsonPOSTREPORTEOPERATIVOSQL);
                    inputStreamPOSTREPORTEOPERATIVOSQL.close();
                    bufferedReaderPOSTREPORTEOPERATIVOSQL.close();
                    JSONObject jsonObjPOSTREPORTEOPERATIVOSQL = new JSONObject(jsonPOSTREPORTEOPERATIVOSQL);
                    if (jsonObjPOSTREPORTEOPERATIVOSQL.get("success").toString() == "true") {
//   TODO     

//        InputStreamReader isr = new InputStreamReader(fileContentpic1, "UTF-8");
//        StringBuilder sb = new StringBuilder();
//        int character;
//        do {
//            character = isr.read();
//            if (character >= 0) {
//                sb.append((char) character);
//            }
//        } while (character >= 0);
//        //System.out.println("sb.toString(); ::" + sb.toString());
//
//        JSONObject jsonObjectpic1 = new JSONObject(sb);
//        System.out.println("jsonObjectpic1 :: " + jsonObjectpic1.toString());

//                     JSONParser jsonParserpic2 = new JSONParser(); 
//                     JSONObject jsonObjectpic2 = (JSONObject)jsonParserpic2.parse( new InputStreamReader(fileContentpic2, "UTF-8")); 
//                     JSONParser jsonParserpic3 = new JSONParser(); 
//                     JSONObject jsonObjectpic3 = (JSONObject)jsonParserpic3.parse( new InputStreamReader(fileContentpic3, "UTF-8"));
//                     System.out.println("jsonObjectpic1 :: "+jsonObjectpic1);
//                     System.out.println("jsonObjectpic2 :: "+jsonObjectpic1);
//                     System.out.println("jsonObjectpic3 :: "+jsonObjectpic3);
//TODO
//        String POSTIMAGENESREPORTE = oProperties.getProperty("POSTIMAGENESREPORTE");
////        String POSTIMAGENESREPORTE = "https://ayd.sadm.gob.mx/appiV3/PostImagenesReporte?ReportNum=050000000705";
//
//        URL urlPOSTIMAGENESREPORTE = new URL(POSTIMAGENESREPORTE + "050000000705");
//        String boundary = Long.toHexString(System.currentTimeMillis()); // Just generate some unique random value.
//        System.out.println("URL urlPOSTIMAGENESREPORTE: " + urlPOSTIMAGENESREPORTE.toString());
//        HttpURLConnection conPOSTIMAGENESREPORTE = (HttpURLConnection) urlPOSTIMAGENESREPORTE.openConnection();
//        conPOSTIMAGENESREPORTE.setRequestMethod("POST");
//        conPOSTIMAGENESREPORTE.setRequestProperty("Content-Type", "application/json; utf-8");
//        conPOSTIMAGENESREPORTE.setDoOutput(true);
//        conPOSTIMAGENESREPORTE.setRequestProperty("Authorization", "Bearer " + token);
//        String jsonInputStringPOSTIMAGENESREPORTE = "{\n"
//                + "  \"" + fileNamepic1 + "\": \"" + fileNamepic4 + "\",\n"
//                + "  \"" + fileNamepic2 + "\": \"" + fileNamepic4 + "\",\n"
//                + "  \"" + fileNamepic3 + "\": \"" + fileNamepic4 + "\",\n"
//                + "  \"" + fileNamepic4 + "\": \"" + fileNamepic4 + "\"\n"
//                + "}";
//        System.out.println("jsonInputStringPOSTIMAGENESREPORTE :: " + jsonInputStringPOSTIMAGENESREPORTE);
//        try (OutputStream osPOSTIMAGENESREPORTE = conPOSTIMAGENESREPORTE.getOutputStream()) {
//            byte[] inputPOSTIMAGENESREPORTE = jsonInputStringPOSTIMAGENESREPORTE.getBytes("utf-8");
//            osPOSTIMAGENESREPORTE.write(inputPOSTIMAGENESREPORTE, 0, inputPOSTIMAGENESREPORTE.length);
//        }
//        try (BufferedReader brPOSTIMAGENESREPORTE = new BufferedReader(
//                new InputStreamReader(conPOSTIMAGENESREPORTE.getInputStream(), "utf-8"))) {
//            String jsonPOSTIMAGENESREPORTE = new String();
//            InputStream inputStreamPOSTIMAGENESREPORTE = conPOSTIMAGENESREPORTE.getInputStream();
//            BufferedReader bufferedReaderPOSTIMAGENESREPORTE = new BufferedReader(new InputStreamReader(inputStreamPOSTIMAGENESREPORTE), 1);
//            String linePOSTIMAGENESREPORTE;
//            while ((linePOSTIMAGENESREPORTE = bufferedReaderPOSTIMAGENESREPORTE.readLine()) != null) {
//                jsonPOSTIMAGENESREPORTE = linePOSTIMAGENESREPORTE;
//            }
//            System.out.println("jsonPOSTREPORTEOPERATIVOSQL response ::: " + jsonPOSTIMAGENESREPORTE);
//            inputStreamPOSTIMAGENESREPORTE.close();
//            bufferedReaderPOSTIMAGENESREPORTE.close();
//            JSONObject jsonObjPOSTIMAGENESREPORTE = new JSONObject(jsonPOSTIMAGENESREPORTE);
//            if (jsonObjPOSTIMAGENESREPORTE.get("success").toString() == "true") {
//
//            } else {
//
//            }
//
//        } catch (JSONException ex) {
//            System.out.println("JSONException POSTIMAGENESREPORTE - ::" + ex);
//
//        }

//TODO
                        String msg = jsonObjPOSTREPORTEOPERATIVOSQL.get("message").toString();
                        System.out.println(dat+" se genero el reporte operativo en jsonPOSTREPORTEOPERATIVOSQL TRUE:::::"+ msg);
                        String strmsg = new String(msg.getBytes("ISO-8859-1"), "UTF-8");
                        out.println("<html>\n"
                                + "<head>\n"
                                + "<meta name=\"tipo_contenido\"  content=\"text/html;\" http-equiv=\"content-type\" charset=\"utf-8\">\n"
                                + "<script src=\"https://unpkg.com/sweetalert/dist/sweetalert.min.js\"></script>\n"
                                + "</head>\n"
                                + "<body>\n"
                                + "<script>\n"
                                + "swal(\"Reporte generado!\", \"" + strmsg + ".\", \"success\").then((value) => {window.parent.location.href='GenerarReportes.jsp'});\n"
                                + "\n"
                                + "</script>\n"
                                + "</body>\n"
                                + "</html>");
                    } else {
                        String msg = jsonObjPOSTREPORTEOPERATIVOSQL.get("message").toString();
                        String strmsg = new String(msg.getBytes("ISO-8859-1"), "UTF-8");
                        System.out.println(dat+" reporte operativo en jsonPOSTREPORTEOPERATIVOSQL  success FALSE:::::" + strmsg);
                        out.println("<html>\n"
                                + "<head>\n"
                                + "<meta name=\"tipo_contenido\"  content=\"text/html;\" http-equiv=\"content-type\" charset=\"utf-8\">\n"
                                + "<script src=\"https://unpkg.com/sweetalert/dist/sweetalert.min.js\"></script>\n"
                                + "</head>\n"
                                + "<body>\n"
                                + "<script>\n"
                                + "swal(\"Reporte no generado!\", \"" + strmsg + ".\", \"error\").then((value) => {window.parent.location.href='GenerarReportes.jsp'});\n"
                                + "\n"
                                + "</script>\n"
                                + "</body>\n"
                                + "</html>");
                    }

                } catch (JSONException ex) {
                    System.out.println("JSONException POSTREPORTEOPERATIVOSQL - ::" + ex);

                }

            } else {
                String msg = jsonObj.get("message").toString();
                String strmsg = new String(msg.getBytes("ISO-8859-1"), "UTF-8");
                System.out.println("reporte operativo en SAP  success FALSE:::::" + strmsg);
                out.println("<html>\n"
                        + "<head>\n"
                        + "<meta name=\"tipo_contenido\"  content=\"text/html;\" http-equiv=\"content-type\" charset=\"utf-8\">\n"
                        + "<script src=\"https://unpkg.com/sweetalert/dist/sweetalert.min.js\"></script>\n"
                        + "</head>\n"
                        + "<body>\n"
                        + "<script>\n"
                        + "swal(\"Reporte no generado!\", \"" + strmsg + ".\", \"error\").then((value) => {window.parent.location.href='GenerarReportes.jsp'});\n"
                        + "\n"
                        + "</script>\n"
                        + "</body>\n"
                        + "</html>");
            }

        } catch (JSONException ex) {
            System.out.println("JSONException ORDENDESERVICIODIRECCIONSAP - ::" + ex);

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
        try {
            processRequest(request, response);
        } catch (ParseException ex) {
            Logger.getLogger(GenerarReporteOperativo.class.getName()).log(Level.SEVERE, null, ex);
        } catch (JSONException ex) {
            Logger.getLogger(GenerarReporteOperativo.class.getName()).log(Level.SEVERE, null, ex);
        }
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
        try {
            processRequest(request, response);
        } catch (ParseException ex) {
            Logger.getLogger(GenerarReporteOperativo.class.getName()).log(Level.SEVERE, null, ex);
        } catch (JSONException ex) {
            Logger.getLogger(GenerarReporteOperativo.class.getName()).log(Level.SEVERE, null, ex);
        }
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
