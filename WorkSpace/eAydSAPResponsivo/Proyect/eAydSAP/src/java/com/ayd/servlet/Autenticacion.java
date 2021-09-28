
package com.ayd.servlet;

import com.ayd.dao.RutaProperties;
import com.ayd.dao.SwitchLoginDTO;
import com.ayd.dao.UsuariosDAO;
import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.security.MessageDigest;
import java.util.ArrayList;
import java.util.Date;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

public class Autenticacion extends HttpServlet {

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
            throws ServletException, IOException, ParseException {
        
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        SwitchLoginDTO sg = new SwitchLoginDTO();
       System.out.println("LoginSwitch::: " + sg.getDetenerLogin());
        if (sg.getDetenerLogin().equalsIgnoreCase("false")) {

            String email = request.getParameter("email");
            System.out.println("email: "+email);
            String password = request.getParameter("password");
            System.out.println("pass: "+password);
            password = sha256(password);
            String IdSistema = "eAyd";

            Properties oProperties = new Properties();
            RutaProperties rp = new RutaProperties();
            InputStream isArchivo = new FileInputStream(rp.getRuta());
            oProperties.load(isArchivo);
            String LOGIN = oProperties.getProperty("LOGIN");
            String INICIO = oProperties.getProperty("INICIO");
            URL url = new URL(LOGIN + email.toLowerCase() + "&Password=" + password + "&IdSistema=" + IdSistema);
            //System.out.println("url :: "+url);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Accept", "application/json");

            if (conn.getResponseCode() != 200) {
                response.sendRedirect("Login.jsp");
                //throw new RuntimeException("Failed : HTTP error code : " + conn.getResponseCode());

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
                    //System.out.println("::jsonObj.get(\"Response\").toString():: "+jsonObj.get("Response").toString());
                    if(jsonObj.get("success").toString().equalsIgnoreCase("true")){
                    if ("null" != jsonObj.get("Response").toString()) {
                        String username=new String();
                        JSONObject jsonObjloginresponse = new JSONObject(jsonObj.get("Response").toString());
                        JSONObject jsonObjloginresponsedata = new JSONObject(jsonObjloginresponse.get("data").toString());
                        if(null!=jsonObjloginresponsedata.get("Usuario").toString()){
                        JSONObject jsonObjloginresponsedatauser = new JSONObject(jsonObjloginresponsedata.get("Usuario").toString());
                        username = jsonObjloginresponsedatauser.get("StrNombre").toString() + " " + jsonObjloginresponsedatauser.get("StrApellidoPaterno").toString() + " " + jsonObjloginresponsedatauser.get("StrApellidoMaterno").toString();

                        }
                        
                        String tokenlogin = jsonObjloginresponsedata.get("Token").toString();
                            Date d=new Date();
                       
                            System.out.println("success LOGIN TRUE::::: "+tokenlogin+" / " + email+" / "+password+" / "+d);
                            HttpSession objSession = request.getSession(true);
                            objSession.setAttribute("usuario", email);
                            objSession.setAttribute("token", tokenlogin);
                            objSession.setAttribute("password", password);
                            objSession.setAttribute("nombreusuario", username);
                             objSession.setAttribute("emailvalido", "false");

                            JSONParser parser = new JSONParser();
                            Object object = parser.parse(new FileReader(rp.getRutajson()));

                            JSONObject jsonObject = new JSONObject(object.toString());
                            ArrayList<UsuariosDAO> usulist = new ArrayList<UsuariosDAO>();
                            JSONArray usuariosjson = jsonObject.getJSONArray("usuarios");
                            for (int i = 0; i < usuariosjson.length(); i++) {
                                JSONObject aux = usuariosjson.getJSONObject(i);
                                //System.out.println("usuario: "+aux.getString("email")+" / activo: "+aux.getString("activo"));

                                if (email.equalsIgnoreCase(aux.getString("email")) && aux.getString("activo").equalsIgnoreCase("true")) {
                                    objSession.setAttribute("emailvalido", "true");
                                    break;
                                } else {
                                    objSession.setAttribute("emailvalido", "false");
                                }
                            }

                            response.sendRedirect(INICIO);
                   
                    } else {
                        System.out.println("success LOGIN FALSE:::::");
                        out.println("<script type=\"text/javascript\">");
                        out.println("window.parent.location.href='sweetAlertAutenticaciónError.html'");
                        out.println("</script>");
                    }}else{
                    System.out.println("success LOGIN FALSE:::::");
                        out.println("<script type=\"text/javascript\">");
                        out.println("window.parent.location.href='sweetAlertAutenticaciónError.html'");
                        out.println("</script>");
                    }
                } catch (IOException ioe) {
                     System.out.println("IOException ");
                   System.out.println("success LOGIN FALSE:::::");
                        out.println("<script type=\"text/javascript\">");
                        out.println("window.parent.location.href='sweetAlertAutenticaciónError.html'");
                        out.println("</script>");
                } catch (JSONException ex) {
                    System.out.println("JSON EXCEPTION");
                   System.out.println("success LOGIN FALSE:::::");
                        out.println("<script type=\"text/javascript\">");
                        out.println("window.parent.location.href='sweetAlertAutenticaciónError.html'");
                        out.println("</script>");
                }

            }

        } else {
            System.out.println("success LOGIN FALSE:::::");
            out.println("<script type=\"text/javascript\">");
            out.println("window.parent.location.href='sweetAlertAutenticaciónSwitch.html'");
            out.println("</script>");
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
             Logger.getLogger(Autenticacion.class.getName()).log(Level.SEVERE, null, ex);
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
             Logger.getLogger(Autenticacion.class.getName()).log(Level.SEVERE, null, ex);
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
