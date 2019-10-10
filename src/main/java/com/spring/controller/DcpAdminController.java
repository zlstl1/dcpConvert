package com.spring.controller;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.spring.vo.UserVo;

@Controller
public class DcpAdminController {

   @RequestMapping(value = "/dcp/{email}/adminpage", method = RequestMethod.GET)
   public String adminpage(Model model, HttpSession session, @PathVariable("email") String email) {
      UserVo userVo = (UserVo)session.getAttribute("user");
      model.addAttribute("user", userVo);
      return "adminpage";
   }
   
   @RequestMapping(value = "/dcp/dashboard", method = RequestMethod.GET)
   public String dashboard() {

      return "/admin/dashboard";
   }

   @RequestMapping(value = "/dcp/admin/cpumonitoring", method = RequestMethod.GET)
   public String admin_cpumonitoring() {

      return "/admin/cpumonitoring";
   }

   @RequestMapping(value = "/dcp/admin/gpumonitoring", method = RequestMethod.GET)
   public String admin_gpumonitoring() {

      return "/admin/gpumonitoring";
   }

   @RequestMapping(value = "/dcp/admin/rammonitoring", method = RequestMethod.GET)
   public String admin_rammonitoring() {

      return "/admin/rammonitoring";
   }

   @RequestMapping(value = "/dcp/userlist", method = RequestMethod.GET)
   public String userlist() {

      return "/admin/userlist";
   }

   @RequestMapping(value = "/dcp/waiting", method = RequestMethod.GET)
   public String waiting() {
      return "/admin/waiting";
   }

   @RequestMapping(value = "/dcp/grade", method = RequestMethod.GET)
   public String grade() {
	   
      return "/admin/dashboard";
   }
   
   
   @RequestMapping(value = "/dcp/cpumonitoring", method = RequestMethod.GET)
   public String cpumonitoring() {

      return "/cpumonitoring";
   }

   @RequestMapping(value = "/dcp/gpumonitoring1", method = RequestMethod.GET)
   public String gpumonitoring1() {

      return "/gpumonitoring1";
   }

   @RequestMapping(value = "/dcp/gpumonitoring2", method = RequestMethod.GET)
   public String gpumonitoring2() {

      return "/gpumonitoring2";
   }
   
   @RequestMapping(value = "/dcp/rammonitoring", method = RequestMethod.GET)
   public String rammonitoring() {

      return "/rammonitoring";
   }
}