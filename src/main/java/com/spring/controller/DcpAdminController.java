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
	   
	      UserVo testUser = new UserVo();
	      testUser.setUser_admin(true);
	      testUser.setUser_id("vlfl1889922");
	      testUser.setUser_name("김경섭");
	      testUser.setUser_no(1);
	      testUser.setUser_storageCapa(25);
	      testUser.setUser_usingGpu(3);
	      session.setAttribute("user", testUser);
	      
      UserVo userVo = (UserVo)session.getAttribute("user");
      model.addAttribute("user", userVo);
      return "adminpage";
   }

   @RequestMapping(value = "/dcp/waiting", method = RequestMethod.GET)
   public String waiting() {
      return "/admin/waiting";
   }

   @RequestMapping(value = "/dcp/grade", method = RequestMethod.GET)
   public String grade() {
	   
      return "/admin/grade";
   }
   
   
   @RequestMapping(value = "/dcp/{email}/cpumonitoring", method = RequestMethod.GET)
   public String cpumonitoring() {

      return "/cpumonitoring";
   }
   
   @RequestMapping(value = "/dcp/{email}/gpumonitoring", method = RequestMethod.GET)
   public String gpumonitoring() {

      return "/gpumonitoring";
   }
   
   
   @RequestMapping(value = "/dcp/{email}/gpumonitoring1", method = RequestMethod.GET)
   public String gpumonitoring1() {

      return "/gpumonitoring1";
   }

   @RequestMapping(value = "/dcp/{email}/gpumonitoring2", method = RequestMethod.GET)
   public String gpumonitoring2() {

      return "/gpumonitoring2";
   }
   
   @RequestMapping(value = "/dcp/{email}/rammonitoring", method = RequestMethod.GET)
   public String rammonitoring() {

      return "/rammonitoring";
   }
   
   @RequestMapping(value = "/dcp/{email}/storage", method = RequestMethod.GET)
   public String storage() {

	   
      return "/storage";
   }
   
   @RequestMapping(value = "/dcp/{email}/userlist", method = RequestMethod.GET)
   public String userlist() {

      return "/userlist";
   }
}