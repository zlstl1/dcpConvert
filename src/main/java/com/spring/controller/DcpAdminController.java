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

import com.spring.service.DcpGroupService;
import com.spring.service.DcpUserService;
import com.spring.vo.GroupVo;
import com.spring.vo.UserVo;

@Controller
public class DcpAdminController {

	@Autowired
	DcpUserService dcpUserService;

	@Autowired
	DcpGroupService dcpGroupService;

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

		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		String join = null;
		String connect = null;

		if (user.getUser_joined() != null) {
			join = formatter.format(user.getUser_joined());
		}
		if (user.getUser_connect() != null) {
			connect = formatter.format(user.getUser_connect());
		}

		JSONObject jobject = new JSONObject();

		jobject.put("user_id", user.getUser_id());
		jobject.put("user_name", user.getUser_name());
		jobject.put("user_email", user.getUser_email());
		jobject.put("user_joined", join);
		jobject.put("user_connect", connect);
		jobject.put("user_status", user.getUser_status());
		jobject.put("user_group", user.getUser_group());
		jobject.put("user_usingGpu", user.getUser_usingGpu());
		jobject.put("user_storageCapa", user.getUser_storageCapa());

		response.setCharacterEncoding("UTF-8");

		PrintWriter out = response.getWriter();
		out.print(jobject);
		out.flush();
		out.close();
	}

	@RequestMapping(value = "/updateuser", method = RequestMethod.POST)
	public void updateuser(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String user_id = request.getParameter("user_id");
		String user_name = request.getParameter("user_name");
		String user_status = request.getParameter("user_status");
		String user_email = request.getParameter("user_email");
		String user_usingGpu = request.getParameter("user_usingGpu");
		String user_storageCapa = request.getParameter("user_storageCapa");
		String user_group = request.getParameter("user_group");

		response.setCharacterEncoding("UTF-8");

		UserVo user = new UserVo();

		user.setUser_id(user_id);
		user.setUser_name(user_name);
		user.setUser_status(user_status);
		user.setUser_email(user_email);
		user.setUser_group(user_group);
		user.setUser_usingGpu(Integer.parseInt(user_usingGpu));
		user.setUser_storageCapa(Integer.parseInt(user_storageCapa));

		dcpUserService.updateuser(user);

		PrintWriter out = response.getWriter();
		out.print(out);
		out.flush();
		out.close();
	}

	@RequestMapping(value = "/dcp/{email}/waiting", method = RequestMethod.GET)
	public String waiting(Model model) {

		ArrayList<UserVo> list = null;
		try {
			list = dcpUserService.getUnapprovedUserList();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		model.addAttribute("list", list);

		return "/waiting";
	}

	@RequestMapping(value = "/dcp/{email}/group", method = RequestMethod.GET)
	public String group(Model model) {

		ArrayList<GroupVo> list = null;
		int count = 0;
		
		try {
			list = dcpGroupService.getGroupList();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		for(int i = 0 ; i < list.size(); i ++) {

			try {
				count = dcpUserService.getGroupCount(list.get(i).getGroup_name());
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			list.get(i).setGroup_count(count);
		}
		
		model.addAttribute("list", list);
		
		return "/group";
	}

	@RequestMapping(value = "/creategroup", method = RequestMethod.POST)
	public void creategroup(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String group_name = request.getParameter("group_name");
		String group_usingGpu = request.getParameter("group_usingGpu");
		String group_storageCapa = request.getParameter("group_storageCapa");

		GroupVo groupvo = new GroupVo();
		groupvo.setGroup_name(group_name);
		groupvo.setGroup_usingGpu(Integer.parseInt(group_usingGpu));
		groupvo.setGroup_storageCapa(Integer.parseInt(group_storageCapa));

		dcpGroupService.insertgroup(groupvo);

		response.setCharacterEncoding("UTF-8");

		PrintWriter out = response.getWriter();
		out.print(out);
		out.flush();
		out.close();
	}
	
	@RequestMapping(value = "/getgroup", method = RequestMethod.POST)
	public void getgroup(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String group_name = request.getParameter("group_name");
		String group_usingGpu = request.getParameter("group_usingGpu");
		String group_storageCapa = request.getParameter("group_storageCapa");
		
		GroupVo group = dcpGroupService.getGroup(group_name);

		JSONObject jobject = new JSONObject();

		jobject.put("group_name", group.getGroup_name());
		jobject.put("group_usingGpu", group.getGroup_usingGpu());
		jobject.put("group_storageCapa", group.getGroup_storageCapa());
		jobject.put("group_no", group.getGroup_no());

		response.setCharacterEncoding("UTF-8");

		PrintWriter out = response.getWriter();
		out.print(jobject);
		out.flush();
		out.close();
	}
	
	@RequestMapping(value = "/delGroup", method = RequestMethod.POST)
	public void delGroup(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String group_name = request.getParameter("group_name");
		
		dcpGroupService.delGroup(group_name);

		response.setCharacterEncoding("UTF-8");

		PrintWriter out = response.getWriter();
		out.print(out);
		out.flush();
		out.close();
	}
	
	@RequestMapping(value = "/selectGroupName", method = RequestMethod.POST)
	public void selectGroupName(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String group_name = request.getParameter("group_name");
		
		ArrayList<GroupVo> list = dcpGroupService.getGroupList();
		
		String result = null;
		
		for(int i = 0 ; i < list.size() ; i++) {
			
			if(group_name.equals(list.get(i).getGroup_name())) {
				result = "false";
				break;
			}
		}
		
		response.setCharacterEncoding("UTF-8");

		PrintWriter out = response.getWriter();
		out.print(result);
		out.flush();
		out.close();
	}
	
	@RequestMapping(value = "/updateGroup", method = RequestMethod.POST)
	public void updateGroup(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String group_no = request.getParameter("group_no");
		String group_name = request.getParameter("group_name");
		String group_usingGpu = request.getParameter("group_usingGpu");
		String group_storageCapa = request.getParameter("group_storageCapa");
	
		response.setCharacterEncoding("UTF-8");

		GroupVo group = new GroupVo();
		
		group.setGroup_no(Integer.parseInt(group_no));
		group.setGroup_name(group_name);
		group.setGroup_usingGpu(Integer.parseInt(group_usingGpu));
		group.setGroup_storageCapa(Integer.parseInt(group_storageCapa));

		dcpGroupService.updateGroup(group);

		PrintWriter out = response.getWriter();
		out.print(out);
		out.flush();
		out.close();
	}
}