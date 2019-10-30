package com.spring.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class ApiController {
	@RequestMapping(value = "/get/single/{type}", method = RequestMethod.POST)
    public void getSingleData(HttpServletResponse response, @PathVariable String type) {
        String address = "http://192.168.0.102:9090/api/v1/query?query=";

        switch (type) {

            case "cpu":
                address += "100-(avg%20by%20(instance)%20(irate(node_cpu_seconds_total{job='node_exporter',mode='idle'}[5m]))*100)";
                break;
            case "cpuClock":
                address += "avg%20by%20(instance)%20(node_cpu_scaling_frequency_hertz)";
                break;
            case "mem":
                address += "((node_memory_MemTotal_bytes-node_memory_MemFree_bytes)/node_memory_MemTotal_bytes)*100";
                break;
            case "disksizetotal":
                address += "node_filesystem_size_bytes";
                break;
                //C free
            case "disksize":
                address += "node_filesystem_free_bytes";
                break;
            case "gpu":
                address += "dcgm_gpu_utilization";
                break;
            case "gpu_clock":
                address += "dcgm_sm_clock";
                break;
            case "gpu_mem":
                address += "dcgm_mem_copy_utilization";
                break;
            case "gpu_temp":
                address += "dcgm_gpu_temp";
                break;
            default:
                break;
        }
        StringBuffer contents = new StringBuffer();
        try {
            URL url = new URL(address);
            HttpURLConnection conn = (HttpURLConnection)url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Content-Type", "text/html");

            int status = conn.getResponseCode();
            System.out.println("response:"+status);
            BufferedReader in = new BufferedReader(
                    new InputStreamReader(conn.getInputStream()));

            String inputLine;
            while ((inputLine = in.readLine()) != null) {
                contents.append(inputLine);
            }
            // System.out.println(content);
            in.close();
        }catch (Exception e){
            e.printStackTrace();
        }
        PrintWriter out = null;
        try {
            out = response.getWriter();
        } catch (IOException e) {
            e.printStackTrace();
        }
        assert out != null;
        out.print(contents);
        out.flush();
        out.close();

    }

    @RequestMapping(value = "/get/{type}", method = RequestMethod.POST)
    public void getdata(HttpServletRequest request, HttpServletResponse response, @PathVariable String type){
        String address = "http://192.168.0.102:9090/api/v1/query_range?query=";
        String start = request.getParameter("start");
        String end = request.getParameter("end");
        String steps = request.getParameter("step");
        switch (type) {
            case "cpu":
                address += "100-(avg%20by%20(instance)%20(irate(node_cpu_seconds_total{job='node_exporter',mode='idle'}[5m]))*100)";
                break;
            case "cpuClock":
                address += "avg%20by%20(instance)%20(node_cpu_scaling_frequency_hertz)";
                break;
            case "mem":
                address += "((node_memory_MemTotal_bytes-node_memory_MemFree_bytes)/node_memory_MemTotal_bytes)*100";
                break;
//            case "diskio":
//                address += "(max(avg(irate(node_disk_io_time_seconds_total[10m])) by (instance, device)) by (instance))/10";
//                break;
            case "disksize":
                address += "node_filesystem_free_bytes";
                break;
            case "gpu":
                address += "dcgm_gpu_utilization";
                break;
            case "gpu_clock":
                address += "dcgm_sm_clock";
                break;
            case "gpu_mem":
                address += "dcgm_mem_copy_utilization";
                break;
            case "gpu_temp":
                address += "dcgm_gpu_temp";
                break;
            default:
                break;
        }

        address += "&start="+start;
        address += "&end="+end;
        address += "&step="+steps;

        System.out.println(address);
        StringBuffer content = new StringBuffer();
        try {
            URL url = new URL(address);
            HttpURLConnection conn = (HttpURLConnection)url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Content-Type", "text/html");

            int status = conn.getResponseCode();
            System.out.println("response:"+status);
            BufferedReader in = new BufferedReader(
                    new InputStreamReader(conn.getInputStream()));

            String inputLine;
            while ((inputLine = in.readLine()) != null) {
                content.append(inputLine);
            }
            // System.out.println(content);
            in.close();
        }catch (Exception e){
            e.printStackTrace();
        }
        PrintWriter out = null;
        try {
            out = response.getWriter();
        } catch (IOException e) {
            e.printStackTrace();
        }
        assert out != null;
        out.print(content);
        out.flush();
        out.close();
    }

}