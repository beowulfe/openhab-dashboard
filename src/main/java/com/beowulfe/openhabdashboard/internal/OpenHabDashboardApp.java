package com.beowulfe.openhabdashboard.internal;

import javax.servlet.ServletException;

import org.osgi.service.component.ComponentContext;
import org.osgi.service.http.HttpService;
import org.osgi.service.http.NamespaceException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class OpenHabDashboardApp {

    public static final String WEBAPP_ALIAS = "/dashboard";
    private final Logger logger = LoggerFactory.getLogger(OpenHabDashboardApp.class);

    protected HttpService httpService;

    protected void activate(ComponentContext componentContext) throws ServletException {
        try {
            httpService.registerResources(WEBAPP_ALIAS, "web", null);
            httpService.registerServlet("/dashboard/index", new OpenHabDashboardServlet(), null, null);
            logger.info("Started dashboard at " + WEBAPP_ALIAS);
        } catch (NamespaceException e) {
            logger.error("Error during servlet startup", e);
        }
    }

    protected void deactivate(ComponentContext componentContext) {
        httpService.unregister(WEBAPP_ALIAS);
        logger.info("Stopped Paper UI");
    }

    protected void setHttpService(HttpService httpService) {
        this.httpService = httpService;
    }

    protected void unsetHttpService(HttpService httpService) {
        this.httpService = null;
    }
}
