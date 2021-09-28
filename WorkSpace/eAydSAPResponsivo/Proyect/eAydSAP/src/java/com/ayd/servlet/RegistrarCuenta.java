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

public class RegistrarCuenta extends HttpServlet {

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

        String userName = request.getParameter("userName");
        String struserName = new String(userName.getBytes("ISO-8859-1"), "UTF-8");
        String lastName = request.getParameter("lastName");
        String strlastName = new String(lastName.getBytes("ISO-8859-1"), "UTF-8");
        String secondLastName = request.getParameter("secondLastName");
        String strsecondLastName = new String(secondLastName.getBytes("ISO-8859-1"), "UTF-8");
        String emails = request.getParameter("emails");
        String street = request.getParameter("street");
        String homeNumber = request.getParameter("homeNumber");
        String homeNumberext = request.getParameter("homeNumberext");
        String district = request.getParameter("district");
        String city = request.getParameter("cityinput");
        //System.out.println("city :::"+city);
        String state = request.getParameter("state");
        String postalCode = request.getParameter("postalCode");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        password = sha256(password);
        String dtNacimiento = request.getParameter("dtNacimiento");
        String sexo = request.getParameter("sexo");
        String NIR1 = request.getParameter("NIR1");
        String IdSistema = "eAyd";

        Properties oProperties = new Properties();
        RutaProperties rp = new RutaProperties();
        InputStream isArchivo = new FileInputStream(rp.getRuta());

        oProperties.load(isArchivo);
        String REGISTRARSE = oProperties.getProperty("REGISTRARSE");
        URL url = new URL(REGISTRARSE);
        //System.out.println("URL REGISTRARSE: "+ url.toString());
        HttpURLConnection con = (HttpURLConnection) url.openConnection();
        con.setRequestMethod("POST");
        con.setRequestProperty("Content-Type", "application/json; utf-8");
        con.setDoOutput(true);
        String jsonInputString = "{\n"
                + "  \"StrNombre\": \"" + struserName + "\",\n"
                + "  \"StrApellidoPaterno\": \"" + strlastName + "\",\n"
                + "  \"StrApellidoMaterno\": \"" + strsecondLastName + "\",\n"
                + "  \"StrEmail\": \"" + emails.toLowerCase() + "\",\n"
                + "  \"StrPassword\": \"" + password + "\"\n"
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
            System.out.println("jsonregistrar ::: " + json);
            inputStream.close();
            bufferedReader.close();
            JSONObject jsonObj = new JSONObject(json);
            if (jsonObj.get("success").toString() == "true") {
                System.out.println("se inserto el usuario TRUE:::::");

                //Obtener token
                String LOGIN = oProperties.getProperty("LOGIN");
                URL urlogin = new URL(LOGIN + emails + "&Password=" + password + "&IdSistema=" + IdSistema);
                HttpURLConnection conn = (HttpURLConnection) urlogin.openConnection();
                conn.setRequestMethod("GET");
                conn.setRequestProperty("Accept", "application/json");

                if (conn.getResponseCode() != 200) {
                    response.sendRedirect("Login.jsp");
                    throw new RuntimeException("Failed : HTTP error code : " + conn.getResponseCode());

                } else {

                    InputStream inputStreamlogin = conn.getInputStream();
                    String jsonlogin = new String();
                    BufferedReader bufferedReaderlogin = new BufferedReader(new InputStreamReader(inputStreamlogin), 1);
                    String linelogin;
                    while ((linelogin = bufferedReaderlogin.readLine()) != null) {
                        jsonlogin = linelogin;
                        System.out.println("jsonlogin ::: " + jsonlogin);
                    }

                    inputStreamlogin.close();
                    bufferedReaderlogin.close();
                    JSONObject jsonObjlogin = new JSONObject(jsonlogin);
                    System.out.println("jsonObjlogin ::: " + jsonObjlogin.toString());
                    JSONObject jsonObjloginresponse = new JSONObject(jsonObjlogin.get("Response").toString());
                    JSONObject jsonObjloginresponsedata = new JSONObject(jsonObjloginresponse.get("data").toString());
                    String tokenlogin = jsonObjloginresponsedata.get("Token").toString();
                    System.out.println("token::: " + tokenlogin);

                    //POST USUARIODATA
                    String POSTUSUARIOS = oProperties.getProperty("POSTUSUARIOS");
                    URL urlpost = new URL(POSTUSUARIOS);
                    HttpURLConnection conuserdata = (HttpURLConnection) urlpost.openConnection();
                    conuserdata.setRequestMethod("POST");
                    conuserdata.setRequestProperty("Content-Type", "application/json; utf-8");
                    conuserdata.setDoOutput(true);
                    conuserdata.setRequestProperty("Authorization", "Bearer " + tokenlogin);
                    String jsonInputStringuserdata = "{\n"
                            + "  \"Nombre\": \"" + struserName + "\",\n"
                            + "  \"ApellidoPaterno\": \"" + strlastName + "\",\n"
                            + "  \"ApellidoMaterno\": \"" + strsecondLastName + "\",\n"
                            + "  \"Email\": \"" + emails.toLowerCase() + "\",\n"
                            + "  \"CP\": \"" + postalCode + "\",\n"
                            + "  \"Ciudad\": \"" + city + "\",\n"
                            + "  \"Colonia\": \"" + district + "\",\n"
                            + "  \"Calle\": \"" + street + "\",\n"
                            + "  \"NumeroExterior\": \"" + homeNumber + "\",\n"
                            + "  \"NumeroInterior\": \"" + homeNumberext + "\",\n"
                            + "  \"Celular\": \"" + phone + "\",\n"
                            + "  \"FechaNacimiento\": \"" + dtNacimiento + "\",\n"
                            + "  \"Sexo\": \"" + sexo + "\",\n"
                            + "  \"Plataforma\": \"eAyd\"\n"
                            + "}";
                    try (OutputStream os = conuserdata.getOutputStream()) {
                        byte[] input = jsonInputStringuserdata.getBytes("utf-8");
                        os.write(input, 0, input.length);
                    }
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
                            System.out.println("success userdata True:::::");
                            //ValidaUsuario
                            String VALIDAUSUARIO = oProperties.getProperty("VALIDAUSUARIO");
                            URL urlvalidauser = new URL(VALIDAUSUARIO + emails);
                            HttpURLConnection convalidateuser = (HttpURLConnection) urlvalidauser.openConnection();
                            convalidateuser.setRequestMethod("GET");
                            convalidateuser.setRequestProperty("Accept", "application/json");

                            if (convalidateuser.getResponseCode() != 200) {
                                response.sendRedirect("Login.jsp");
                                throw new RuntimeException("Failed : HTTP error code : " + convalidateuser.getResponseCode());

                            } else {
                                System.out.println("Correo de validación enviado");
                                //TODO UpdServicio
                            }

                            String msg = jsonObjuserdata.get("message").toString();
                            String strmsg = new String(msg.getBytes("ISO-8859-1"), "UTF-8");
                            System.out.println("success TRUE:::::");
                            out.println("<script type=\"text/javascript\">");
                            out.println("location='sweetAlertRegiCtatrue.html'");
                            out.println("</script>");

                        } else {
                            System.out.println("success userdata FALSE:::::");
                            String msg = jsonObjuserdata.get("message").toString();
                            String strmsg = new String(msg.getBytes("ISO-8859-1"), "UTF-8");

                            System.out.println("success FALSE::::: " + strmsg);
                            out.println("<script type=\"text/javascript\">");
                            out.println("location='sweetAlertRegisCtafalse.html'");
                            out.println("</script>");
                        }
                    }
                }

            } else {
                String msg = jsonObj.get("message").toString();
                String strmsg = new String(msg.getBytes("ISO-8859-1"), "UTF-8");
                System.out.println("success FALSE:::::" + strmsg);
                out.println("<html>\n"
                        + "<head>\n"
                        + "<meta name=\"tipo_contenido\"  content=\"text/html;\" http-equiv=\"content-type\" charset=\"utf-8\">\n"
                        + "<script src=\"https://unpkg.com/sweetalert/dist/sweetalert.min.js\"></script>\n"
                        + "</head>\n"
                        + "<body>\n"
                        + "<script>\n"
                        + "swal(\"No registrado!\", \"" + strmsg + ".\", \"error\").then((value) => {window.parent.location.href='Login.jsp'});\n"
                        + "\n"
                        + "</script>\n"
                        + "</body>\n"
                        + "</html>");
//                //out.println("alert('" + strmsg + "');");
//                out.println("location='Login.jsp'");
//                out.println("</script>");
            }

        } catch (JSONException ex) {
            Logger.getLogger(RegistrarCuenta.class.getName()).log(Level.SEVERE, null, ex);
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
