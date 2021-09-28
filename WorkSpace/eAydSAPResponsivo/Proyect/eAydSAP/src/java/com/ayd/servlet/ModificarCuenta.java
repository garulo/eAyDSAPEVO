
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


public class ModificarCuenta extends HttpServlet {

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
        String userName = request.getParameter("userName");
        String struserName = new String(userName.getBytes("ISO-8859-1"), "UTF-8");
        String lastName = request.getParameter("lastName");
        String strlastName = new String(lastName.getBytes("ISO-8859-1"), "UTF-8");
        String secondLastName = request.getParameter("secondLastName");
        String strsecondLastName = new String(secondLastName.getBytes("ISO-8859-1"), "UTF-8");
        String email = request.getParameter("email2");

        String street = request.getParameter("street");
        String strstreet = new String(street.getBytes("ISO-8859-1"), "UTF-8");
        String homeNumber = request.getParameter("homeNumber");
        String homeNumberext = request.getParameter("homeNumberext");
        String district = request.getParameter("district");
        String strdistrict = new String(district.getBytes("ISO-8859-1"), "UTF-8");
        String city = request.getParameter("cityinput");
        String strcity = new String(city.getBytes("ISO-8859-1"), "UTF-8");
        String state = request.getParameter("state");
        String strstate = new String(state.getBytes("ISO-8859-1"), "UTF-8");
        String postalCode = request.getParameter("postalCode");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String dtNacimiento = request.getParameter("dtNacimiento");
        String sexo = request.getParameter("sexo");
        String NIR1 = request.getParameter("NIR1");
        String passwordactual = request.getParameter("passwordactual");
        String IdSistema = "eAyd";

        Properties oProperties = new Properties();
    
        oProperties.load(isArchivo);
        String POSTUSUARIOS = oProperties.getProperty("POSTUSUARIOS");
        URL urlpost = new URL(POSTUSUARIOS);
        HttpURLConnection conuserdata = (HttpURLConnection) urlpost.openConnection();
        conuserdata.setRequestMethod("POST");
        conuserdata.setRequestProperty("Content-Type", "application/json; utf-8");
        conuserdata.setDoOutput(true);
        conuserdata.setRequestProperty("Authorization", "Bearer " + token);
        long lgcity = Long. parseLong(strcity) ;
        long lgdist = Long. parseLong(strdistrict) ;;
        long lgstreet = Long. parseLong(strstreet) ;;
        String jsonInputStringuserdata = "{\n"
                + "  \"Nombre\": \"" + struserName + "\",\n"
                + "  \"ApellidoPaterno\": \"" + strlastName + "\",\n"
                + "  \"ApellidoMaterno\": \"" + strsecondLastName + "\",\n"
                + "  \"Email\": \"" + email.toLowerCase() + "\",\n"
                + "  \"CP\": \"" + postalCode + "\",\n"
                + "  \"Ciudad\": " + lgcity + ",\n"
                + "  \"Colonia\": " + lgdist + ",\n"
                + "  \"Calle\": " + lgstreet + ",\n"
                + "  \"NumeroExterior\": " + homeNumberext + ",\n"
                + "  \"NumeroInterior\": " + homeNumber + ",\n"
                + "  \"Celular\": \"" + phone + "\",\n"
                + "  \"FechaNacimiento\": \"" + dtNacimiento + "\",\n"
                + "  \"Sexo\": \"" + sexo + "\",\n"
                + "  \"Plataforma\": \"eAyd\"\n"
                + "}";
        try (OutputStream os = conuserdata.getOutputStream()) {
            byte[] input = jsonInputStringuserdata.getBytes("utf-8");
            os.write(input, 0, input.length);
        }
        System.out.println("jsonInputStringuserdata ::: " + jsonInputStringuserdata);
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
                System.out.println("jsonObjuserdata true ::::: " + jsonObjuserdata.get("Response").toString());
                response.sendRedirect("UserEdit.jsp");

            }
        } catch (JSONException ex) {
            Logger.getLogger(ModificarCuenta.class.getName()).log(Level.SEVERE, null, ex);
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
