package com.spring.controller;

import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.spring.service.DcpUserService;
import com.spring.vo.UserVo;

@Controller
public class DcpAdminController {

	@Autowired
	DcpUserService dcpUserService;

	@RequestMapping(value = "/dcp/{email}/adminpage", method = RequestMethod.GET)
	public String adminpage(Model model, HttpSession session, @PathVariable("email") String email) {
		UserVo userVo = (UserVo) session.getAttribute("user");
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
	public String userlist(Model model) {
		ArrayList<UserVo> list = null;
		try {
			list = dcpUserService.getUserList();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		model.addAttribute("list", list);
		
		return "/userlist";
	}
	
	@RequestMapping(value = "/deleteuser", method = RequestMethod.POST)
    public void deleteuser(HttpServletRequest request, HttpServletResponse response) throws Exception {
		 String user_id = request.getParameter("user_id");
		
		dcpUserService.deleteuser(user_id);

        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();
        out.print(out);
        out.flush();
        out.close();
    }
	
	@RequestMapping(value = "/getuser", method = RequestMethod.POST)
    public void getuser(HttpServletRequest request, HttpServletResponse response) throws Exception {
		 String user_id = request.getParameter("user_id");
		
		UserVo user = dcpUserService.getuser(user_id);
		
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd hh:mm");
		String join = null;
		String connect = null;
		
		if(user.getUser_joined()!=null) {
			join = formatter.format(user.getUser_joined());
		}
		if(user.getUser_connect()!=null) {
			connect = formatter.format(user.getUser_connect());
		}
		
		JSONObject jobject = new JSONObject();
		
		jobject.put("user_id", user.getUser_id());
		jobject.put("user_name", user.getUser_name());
		jobject.put("user_grade", user.getUser_grade());
		jobject.put("user_email", user.getUser_email());
		jobject.put("user_joined", join);
		jobject.put("user_connect", connect);
		jobject.put("user_status", user.getUser_status());
		jobject.put("user_usingGpu", user.getUser_usingGpu());
		jobject.put("user_storageCapa", user.getUser_storageCapa());
		
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();
        out.print(jobject);
        out.flush();
        out.close();
    }
}