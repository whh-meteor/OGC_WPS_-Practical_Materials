package org.n52.wps.server.algorithm;

import org.n52.wps.algorithm.annotation.Algorithm;
import org.n52.wps.algorithm.annotation.ComplexDataInput;
import org.n52.wps.algorithm.annotation.Execute;
import org.n52.wps.server.AbstractAnnotatedAlgorithm;
import org.n52.wps.algorithm.annotation.LiteralDataOutput;
import org.n52.wps.io.data.GenericFileData;
import org.n52.wps.io.data.binding.complex.GenericFileDataBinding;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.io.File;
import java.lang.reflect.Method;
import java.net.URL;
import java.net.URLClassLoader;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;


/**
 * desc: <br />
 * Date: 2023/8/18 <br/>
 *
 * @author wanghaihang
 */
@Algorithm(version = "1.1.1",
        identifier = "matlab.CVAProcess",
        title="matlab.CVAProcess",
        abstrakt = "This is CVAMulBandsAlgorithm image processing algorithm.")
//@Slf4j
public class CVA extends AbstractAnnotatedAlgorithm {
    //定义处理id
    private String processId="matlab.CVAProcess";
    //定义jar包的位置
    private String jarPath="E://WPS-3.6.2/WPS-3.6.2/52n-wps-algorithm-impl/lib/CVAMulBands.jar";
    //定义matlab封装的方法名
    private String methodName="CVAMulBands";
    //定义数据存放路径tomcat下面
    private String tomcatDir="E:/Tomcat/apache-tomcat-9.0.34/webapps/";

    public GenericFileData source;
    private List<GenericFileData> data;
    private static final Logger log = LoggerFactory.getLogger(EchoProcess.class);
    private String literalOutput;

    @SuppressWarnings("unused")
    public CVA() {
    }

    @ComplexDataInput(identifier = "source", binding = GenericFileDataBinding.class,minOccurs=1, maxOccurs=2)
    @SuppressWarnings("unused")
    public void setData(List<GenericFileData> data) {
        log.info(String.valueOf(data));
        this.data = data; }

    @LiteralDataOutput(identifier = "literalOutput")
    public String getLiteralOutput() { return literalOutput; }

    @Execute
    @SuppressWarnings("unused")
    public void run() {

        GenericFileData a1 = data.get(0);
        GenericFileData b1 = data.get(1);

       // 直接获取文件路径,无需创建File对象
String x1 = a1.getBaseFile().getAbsolutePath(); 
String y1 = b1.getBaseFile().getAbsolutePath();

// 使用简短的日期格式化   
String fileName = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());

// 直接使用反射调用方法,无需先获取Method对象
Class<?> clazz = classLoader.loadClass(processId + ".Matlab");
clazz.getConstructor().newInstance()
     .invoke(methodName, 1, new Object[]{x1, y1, outputfile}); 

// 使用JSONObject构建JSON  
JSONObject json = new JSONObject();
json.put("code", "200");
json.put("filename", fileName + ".tif");
json.put("fileurl", fileurl);  
json.put("imagetype", "Intensity");

literalOutput = json.toString();
    }
}