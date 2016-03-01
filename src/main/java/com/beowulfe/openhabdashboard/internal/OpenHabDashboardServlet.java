package com.beowulfe.openhabdashboard.internal;

import java.io.File;
import java.io.FileReader;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.eclipse.smarthome.config.core.ConfigConstants;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class OpenHabDashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final Logger logger = LoggerFactory.getLogger(OpenHabDashboardServlet.class);

    private final File dashboardDir;

    public OpenHabDashboardServlet() {
        dashboardDir = new File(ConfigConstants.getUserDataFolder() + File.separator + "dashboards");
        if (!dashboardDir.exists()) {
            if (!dashboardDir.mkdirs()) {
                logger.error("Could not create dashboard dir " + dashboardDir.getAbsolutePath());
            }
            logger.info("Created dashboard directory " + dashboardDir.getAbsolutePath());
        } else {
            logger.info("Serving dashboards from " + dashboardDir.getAbsolutePath());
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pageParam = req.getParameter("page");
        if (pageParam == null) {
            pageParam = "index";
        }
        File file = new File(dashboardDir, pageParam + ".html");
        if (!file.exists()) {
            logger.warn("Could not locate dashboard: " + file.getAbsolutePath());
            resp.sendError(404);
            return;
        }
        resp.setContentType("text/html");
        try (FileReader reader = new FileReader(file)) {
            IOUtils.copy(reader, resp.getWriter());
        }
    }

}
