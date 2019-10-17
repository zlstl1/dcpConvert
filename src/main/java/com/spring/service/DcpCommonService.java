package com.spring.service;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.util.Common;

import net.lingala.zip4j.core.ZipFile;
import net.lingala.zip4j.model.ZipParameters;
import net.lingala.zip4j.util.Zip4jConstants;

@Service
public class DcpCommonService {
	@Autowired
	Common common;
	
//	public void uploadMedia(MultipartFile file, String workDir) {
//		saveFile(workDir, file);
//		String ffmpeg = common.getLibDir() + "\\ffmpeg\\ffmpeg.exe ";
//		String orgName = file.getOriginalFilename();
//		String cli = "-n -i " + orgName;
//		
//		String fileName = FilenameUtils.getBaseName(file.getOriginalFilename());
//		
//		cli += " -c:v h264_nvenc -preset fast -b:v 1000K -maxrate 1000K .\\" + fileName + ".mp4";
//		runCli(ffmpeg + cli,workDir);
//	}
	
    public void zipDir(String zip_path) {
        String zipFileName = zip_path+".zip";       
        
        try {
             ZipFile zipfile = new ZipFile(zipFileName);
             ZipParameters parameters = new ZipParameters();
             parameters.setCompressionMethod(Zip4jConstants.COMP_DEFLATE);
             parameters.setCompressionLevel(Zip4jConstants.DEFLATE_LEVEL_FASTEST);
             zipfile.addFolder(zip_path, parameters);
         } catch (Exception e) {
         }
    }
    
    public int getPlayTime2(String originalFilename, String workDir) {
    	String cmd[] = new String[] {
    			"ffmpeg",
    			"-i",workDir + "/" + originalFilename
    	};
    	int frame = 0;
    	BufferedReader br = null;
    	
    	try {
    			ProcessBuilder builder = new ProcessBuilder();
    			builder.redirectErrorStream(true);
    			builder.command(cmd);
    			builder.directory(new File(workDir));
    			
    			Process p = builder.start();
    			//p.getInputStream().close();
				p.getErrorStream().close(); 
				p.getOutputStream().close(); 
				
				br = new BufferedReader(new InputStreamReader(p.getInputStream()));
				String line;
				while ((line = br.readLine()) != null) {
					if(line.contains("NUMBER_OF_FRAMES:")) {
						line = line.replaceFirst("NUMBER_OF_FRAMES:", ""); 
						line = line.trim();
	                  
						frame = Integer.parseInt(line);
						
						break;
					}
				}
				p.waitFor();
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
		    try {
		        if( br!=null ) {
		        	br.close();
		        }
		    } catch(IOException e) {
		    }
		}
    	return frame;
    }
    
    public int getPlayTime(String originalFilename, String workDir) {
    	String cmd[] = new String[] {
    			"ffprobe",
    			"-select_streams","v",
    			"-show_streams",workDir + "/" + originalFilename
    	};
    	int frame = 0;
    	BufferedReader br = null;
    	
    	try {
    			ProcessBuilder builder = new ProcessBuilder();
    			builder.redirectErrorStream(true);
    			builder.command(cmd);
    			builder.directory(new File(workDir));
    			
    			Process p = builder.start();
    			//p.getInputStream().close();
				p.getErrorStream().close(); 
				p.getOutputStream().close(); 
				
				br = new BufferedReader(new InputStreamReader(p.getInputStream()));
				String line;
				while ((line = br.readLine()) != null) {
					if(line.contains("nb_frames=")) {
						line = line.replaceFirst("nb_frames=", ""); 
						line = line.trim();
	                 
						if("N/A".equals(line)) {
							frame = -1;
						}else {
							frame = Integer.parseInt(line);
						}
						
						break;
					}
				}
				p.waitFor();
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
		    try {
		        if( br!=null ) {
		        	br.close();
		        }
		    } catch(IOException e) {
		    }
		}
    	return frame;
    }
    
	public void makeDir(String outputDir) {
		File desti = new File(outputDir);	
		
		if(!desti.exists()){				
			desti.mkdirs(); 
		}
	}
	
//	public void runCli(String cli, String workDir) {
//		Process p = null;
//		try{ 
//			p = Runtime.getRuntime().exec(cli, null, new File(workDir)); 
//			p.getErrorStream().close(); 
//			//p.getInputStream().close(); 
//			p.getOutputStream().close(); 
//			p.waitFor();
//		}catch(Exception e){ 
//			System.out.println(e); 
//		}finally{
//			if(p != null) {
//				try {
//					p.getInputStream().close();
//				} catch (IOException e) {
//					// TODO Auto-generated catch block
//					e.printStackTrace();
//				} 
//			}
//		}
//	}
	
	public void runCli(String cli, String workDir) {
		BufferedReader br = null;
		Process p = null;
		try {
			ProcessBuilder builder = new ProcessBuilder();
			builder.redirectErrorStream(true);
			builder.command(cli);
			builder.directory(new File(workDir));
			
			//p = Runtime.getRuntime().exec(cli, null, new File(workDir)); 
			p = builder.start();
			//p.getInputStream().close();
			p.getErrorStream().close(); 
			p.getOutputStream().close(); 
			
			br = new BufferedReader(new InputStreamReader(p.getInputStream()));
			String line;
			while ((line = br.readLine()) != null) {
				//System.out.println("runCli ERROR = " + line);
			}
			p.waitFor();
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
		    try {
		        if( br!=null ) {
		        	br.close();
		        }
		        if( p != null) {
		        	p.getInputStream().close();
		        }
		    } catch(IOException e) {
		    }
		}
	}
	
	public void runCli(String[] cli, String workDir) {
		BufferedReader br = null;
		Process p = null;
		try {
			ProcessBuilder builder = new ProcessBuilder();
			builder.redirectErrorStream(true);
			builder.command(cli);
			builder.directory(new File(workDir));
			
			//p = Runtime.getRuntime().exec(cli); 
			p = builder.start();
			//p.getInputStream().close();
			p.getErrorStream().close(); 
			p.getOutputStream().close(); 
			
			br = new BufferedReader(new InputStreamReader(p.getInputStream()));
			String line;
			while ((line = br.readLine()) != null) {
				//System.out.println("runCli ERROR = " + line);
			}
			p.waitFor();
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
		    try {
		        if( br!=null ) {
		        	br.close();
		        }
		        if( p != null) {
		        	p.getInputStream().close();
		        }
		    } catch(IOException e) {
		    }
		}
	}
	
}
