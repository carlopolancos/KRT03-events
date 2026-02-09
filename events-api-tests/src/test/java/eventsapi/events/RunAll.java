package eventsapi.events;

import org.junit.jupiter.api.Test;
import java.io.File;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.stream.Collectors;
import com.intuit.karate.Results;
import com.intuit.karate.Runner;

import net.masterthought.cucumber.Configuration;
import net.masterthought.cucumber.ReportBuilder;
import static org.junit.jupiter.api.Assertions.assertTrue;

import org.apache.commons.io.FileUtils;
class RunAll {
	 @Test    
	 public void testParallel() {
		 
		 File file = new File("target/cucumber-html-reports/");
	        String[] myFiles;
	        if (file.isDirectory()) {
	            myFiles = file.list();
	            for (int i = 0; i < myFiles.length; i++) {
	                File myFile = new File(file, myFiles[i]);
	                System.out.println("Deleting files: " + myFile);
	                myFile.delete();
	            }
	        }
	        
	        
	        Results results = Runner.path("classpath:eventsapi/events/")
	        		.tags("~@ignore") 
	                .outputCucumberJson(true)
	                .parallel(5);
	        generateReport(results.getReportDir());
	        assertTrue(results.getFailCount() == 0, results.getErrorMessages());

		 
	 }
	 
	 public static void generateReport(String karateOutputPath) {
	        Collection<File> jsonFiles = FileUtils.listFiles(new File(karateOutputPath), new String[]{"json"}, true);
	        List<String> jsonPaths = jsonFiles.stream()
	                .map(File::getAbsolutePath)
	                .collect(Collectors.toList());

	        Configuration config = new Configuration(new File("target"), "Events API Test Report");
	        ReportBuilder reportBuilder = new ReportBuilder(jsonPaths, config);
	        reportBuilder.generateReports();
	    }

}

 
