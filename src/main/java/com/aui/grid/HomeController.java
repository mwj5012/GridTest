package com.aui.grid;

import java.text.DateFormat;
import java.util.Date;
import java.util.Locale;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	/**
	 * Simply selects the home view to render by returning its name.
	 */
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		
		Date date = new Date();
		DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);
		
		String formattedDate = dateFormat.format(date);
		
		model.addAttribute("serverTime", formattedDate );
		
		return "home";
	}
	
	/* PDF 다운로드 */
	@RequestMapping(value = "/auiPDF", method = RequestMethod.POST)
	public String PDF() {
		System.out.println("PDF 다운로드");
		
		return "export/export";	// export.jsp의 위치
	}
	
	/* Excel 다운로드 */
	@RequestMapping(value = "/auiEXCEL", method = RequestMethod.POST)
	public String EXCEL() {
		System.out.println("Excel 다운로드");
		
		return "export/export";
	}
	
	/*  셀 세로 병합 */
	@RequestMapping(value = "/cellMerge/rowSpan", method = RequestMethod.GET)
	public String cellMergeRowSpan() {
		
		return "/cellMerge/rowSpan";
	}
	
	/* 셀 가로 병합 */
	@RequestMapping(value = "/cellMerge/columnSpan", method = RequestMethod.GET)
	public String cellMergeColumnSpan() {
		
		return "/cellMerge/columnSpan";
	}
	
	/* crud 테스트 */
	@RequestMapping(value = "/crud/crud", method = RequestMethod.GET)
	public String crudTest() {
		
		return "/crud/crud";
	}
	
	/* 그리드 생성 */
	@RequestMapping(value = "/crud/createGrid", method = RequestMethod.GET)
	public String createGrid() {
		
		return "/crud/createGrid";
	}
	
	
	
	
	
	/* JS 예제 */
	@RequestMapping(value = "/jsExam/jsExam", method = RequestMethod.GET)
	@ResponseBody
	public String jsExam(@RequestParam("value1") String value1, @RequestParam("value2") int value2) {
		System.out.println("테스트1 : " + value1 + ", " + "테스트2 : " + value2);
		
		return "/jsExam/jsExam";
	}
	
	
	
	
	/*
	 * 선사 관리
	 */
	@RequestMapping(value="/exam/shippingCompanyMng", method = RequestMethod.GET)
	public String scMng() {
		System.out.println("선사 관리 페이지");
		
		return "/exam/shippingCompanyMng";
	}
}
