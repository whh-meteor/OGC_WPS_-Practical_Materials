
from pywps import Process, LiteralInput, \
        ComplexInput, ComplexOutput, Format, FORMATS


from pywps.validator.mode import MODE

__author__ = 'Brauni'


class demobuffer(Process):
    def __init__(self):
        inputs = [ComplexInput('poly_in', 'Input vector file',
                  supported_formats=[Format('application/gml+xml')],
                  mode=MODE.STRICT),
                  LiteralInput('buffer', 'Buffer size', data_type='float',
                  allowed_values=(0, 1, 10, (10, 10, 100), (100, 100, 1000)))]
        outputs = [ComplexOutput('buff_out', 'Buffered file',
                                 supported_formats=[
                                            Format('application/gml+xml')
                                            ]
                                 )]

        super(demobuffer, self).__init__(
            self._handler,
            identifier='demobuffer',
            version='0.1',
            title="GDAL Buffer process",
            abstract="""手动发布一个WPS服务示例""",
            profile='',
            inputs=inputs,
            outputs=outputs,
            store_supported=True,
            status_supported=True
        )

    def _handler(self, request, response):
        from osgeo import ogr

        inSource = ogr.Open(request.inputs['poly_in'][0].file)

        inLayer = inSource.GetLayer()
        out = inLayer.GetName() + '_buffer'

         # 创建输出文件
        driver = ogr.GetDriverByName('GML')
        outSource = driver.CreateDataSource(
                                out,
                                ["XSISCHEMAURI=\
                            http://schemas.opengis.net/gml/2.1.2/feature.xsd"])
        outLayer = outSource.CreateLayer(out, None, ogr.wkbUnknown)

        # 获取要素数量
        featureCount = inLayer.GetFeatureCount()
        index = 0
        # 为每个要素创建缓冲区
        while index < featureCount:
            # 获取 geometry
            inFeature = inLayer.GetNextFeature()
            inGeometry = inFeature.GetGeometryRef()

            # 做缓冲分析
            buff = inGeometry.Buffer(float(request.inputs['buffer'][0].data))

            # 将输出要素创建到文件
            outFeature = ogr.Feature(feature_def=outLayer.GetLayerDefn())
            outFeature.SetGeometryDirectly(buff)
            outLayer.CreateFeature(outFeature)
            outFeature.Destroy()  # makes it crash when using debug
            index += 1

            response.update_status('Buffering', 100*(index/featureCount))

        outSource.Destroy()
        # 设置输出格式
        response.outputs['buff_out'].output_format = FORMATS.GML
        # 将输出数据设置为文件名
        response.outputs['buff_out'].file = out

        return response
