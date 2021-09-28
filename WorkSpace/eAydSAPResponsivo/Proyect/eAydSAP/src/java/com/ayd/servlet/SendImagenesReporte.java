package com.ayd.servlet;

import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.nio.file.Paths;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@MultipartConfig
public class SendImagenesReporte extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        Part pic1 = request.getPart("pic1");
        String fileName = Paths.get(pic1.getSubmittedFileName()).getFileName().toString();
        InputStream fileContent = pic1.getInputStream();
        System.out.println("pic1: " + fileName);
        Part pic2 = request.getPart("pic2");
        String fileNamepic2 = Paths.get(pic2.getSubmittedFileName()).getFileName().toString();
        InputStream fileContentpic2 = pic2.getInputStream();
        System.out.println("pic2: " + fileNamepic2);
        Part pic3 = request.getPart("pic3");
        String fileNamepic3 = Paths.get(pic3.getSubmittedFileName()).getFileName().toString();
        InputStream fileContentpic3 = pic3.getInputStream();
        System.out.println("pic3: " + fileNamepic3);
        
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet SendImagenesReporte</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet SendImagenesReporte at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
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
