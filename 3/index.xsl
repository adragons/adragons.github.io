<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output
    method="html"
    encoding="UTF-8"
    indent="yes"
    media-type="text/html"
    omit-xml-declaration="yes"
    doctype-system="html" />

<xsl:variable name="countries" select="document('countries.xml')/countries" />
<!-- <xsl:key name="keyCountries" match="country" use="@name" /> -->
<xsl:variable name="attacks" select="/casualties" />
<!-- <xsl:key name="keyAttacks" match="attack" use="@country" /> -->

<xsl:template match="/">
    <html>
    <head>
        <meta charset="utf-8" />
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
        <title>Jihad</title>
        <link rel="stylesheet" type="text/css" href="../css.css" />
    </head>
    <body>
        <style type="text/css">
            x {
                height: 1rem;
                line-height: 1rem;
                background-color: red;
                display: inline-block;
                font-size: .75rem;
                font-family: monospace;
            }
            z {
                height: 1rem;
                line-height: 1rem;
                background-color: orange;
                display: inline-block;
                font-size: .75rem;
                font-family: monospace;
            }
            table td {
                white-space: pre;
                font-size: 1rem;
            }
            table {
                border-spacing: 5px;
                border-collapse: separate;
                line-height: 14px;
            }
            th {
                text-align: left;
            }
            #pixel {
                display: none;
                background-color: pink;
                height: 1px;
                width: 1px;
                font-size: 0;
                position: fixed;
            }
            html, body {
                scroll-snap-type: y proximity;
            }
            #map, content {
                scroll-snap-align: start;
            }
        </style>
         

        <content class="" style="margin:0 auto; max-width:80ch;">

            <p><a href="../index.html">&lt; Index</a></p>

            <h1>Jihad map</h1>

            <div id="map" style="height:70vh; margin: 0 -2em"></div>
            <div style="margin-bottom: -4rem;z-index: 2;position: relative;">
                <br />
                <select onchange="selectCountry(this.value, true)" id="countryList">
                    <option value="">All Locations</option>
                    <xsl:for-each select="$countries/country[@name=$attacks/a/@country]">
                        <xsl:sort select="@name"/>
                        <option>
                            <xsl:attribute name="value"><xsl:value-of select="@name" /></xsl:attribute>
                            <xsl:value-of select="concat(current()/@name, ' ', @flag)" />
                        </option>
                    </xsl:for-each>
                </select>
                <br />
                <z style="width:1rem;"></z> Injured: <span id="injured"><xsl:attribute name="data-count"><xsl:value-of select="sum(/casualties/a/@injured)" /></xsl:attribute></span><br />
                <x style="width:1rem;"></x> Killed: <span id="killed"><xsl:attribute name="data-count"><xsl:value-of select="sum(/casualties/a/@killed)" /></xsl:attribute></span><br />
            </div>

            <div id="graph"></div>

            <p>
            <note>Source: https://thereligionofpeace.com/</note>
            </p>
        </content>

        <script>
            ol.proj.useGeographic();

            const style = new ol.style.Style({
                fill: new ol.style.Fill({
                    color: '#eeeeee',
                }),
                stroke: new ol.style.Stroke({
                    color: 'rgba(0,0,0,0.5)'
                })
            });

            var vl = new ol.layer.Vector({
                background: '#1a2b39',
                imageRatio: 2,
                source: new ol.source.Vector({
                    url: 'countries.geojson',
                    format: new ol.format.GeoJSON(),
                }),
                style: function (feature) {
                    const color = feature.get('COLOR') || '#eeeeee';
                    style.getFill().setColor(color);
                    return style;
                },
            });

            var map = new ol.Map({
                target: 'map',
                layers: [
                    vl
                ],
                view: new ol.View({
                    center: [0,40],
                    zoom: 1
                })
            });

            const affectedOverlay = new ol.layer.Vector({
                source: new ol.source.Vector(),
                map: map,
                style: new ol.style.Style({
                    stroke: new ol.style.Stroke({
                        color: 'rgba(0, 0, 100, 0.5)',
                        width: 2,
                    }),
                    fill: new ol.style.Fill({
                        color: 'rgba(0, 0, 100, 0.15)'
                    })
                }),
            });

            const featureOverlay = new ol.layer.Vector({
                source: new ol.source.Vector(),
                map: map,
                style: new ol.style.Style({
                    stroke: new ol.style.Stroke({
                        color: 'rgba(255, 0, 0, 0.7)',
                        width: 2,
                    }),
                    fill: new ol.style.Fill({
                        color: 'rgba(255,0,0,0.15)'
                    })
                }),
            });

            const selectOverlay = new ol.layer.Vector({
                source: new ol.source.Vector(),
                map: map,
                style: new ol.style.Style({
                    stroke: new ol.style.Stroke({
                        color: 'rgba(0, 0, 0, 0.7)',
                        width: 2,
                    }),
                    fill: new ol.style.Fill({
                        color: 'rgba(40,255,40,1)'
                    })
                }),
            });

            map.set('hash-load', false);
            map.on('postrender', function(e) {
                if (e.frameState.index === 2) {
                    if (map.get('hash-load')) return;

                    map.set('hash-load', true);

                    let hash = window.location.hash.substr(1);
                    if (hash.length) {
                        selectCountry(hash, true, true);
                    }
                }
            });

            let highlight;
            let select = null;

            var hoverFeature = function(pixel) {
                var feature = map.forEachFeatureAtPixel(pixel, function(feature) {
                    return feature;
                });
                if (highlight &amp;&amp; !feature) {
                    featureOverlay.getSource().removeFeature(highlight);
                }
                if (!feature) return;

                featureOverlay.getSource().clear();

                if (feature) {
                    featureOverlay.getSource().addFeature(feature);
                }
                highlight = feature;
            };

            var selectFeature = function (pixel) {
                var feature = map.forEachFeatureAtPixel(pixel, function(feature) {
                    return feature;
                });
                if (!feature) return;
                if (highlight) {
                    featureOverlay.getSource().removeFeature(highlight);
                    highlight = null;
                }

                selectOverlay.getSource().clear();
                if (feature) {
                    selectOverlay.getSource().addFeature(feature);
                    selectCountry(getCountryNameFromFeature(feature), false, true);
                }
                select = feature;

            };

            map.on('pointermove', function(evt) {
                if (evt.dragging) {
                    return;
                }
                var pixel = map.getEventPixel(evt.originalEvent);
                hoverFeature(pixel);
            });

            map.on('click', function(evt) {
                selectFeature(evt.pixel);
            });

            const countryMap = {
                'USA': 'United States of America',
                'Pal. Auth.' : 'West Bank',
                'Russia': 'Russia',
                'Chechnya': 'Russia',
                'Dagestan': 'Russia',
                'England': 'United Kingdom',
                'Wales': 'United Kingdom',
                'Scotland': 'United Kingdom',
                'Bahrain': 'Qatar',
                'CAR': 'Central African Republic',
                'Maldives': 'India',
                'Serbia': 'Republic of Serbia',
                'Tanzania': 'United Republic of Tanzania'
            };
            let featureMap = {};
            (async function(){
                let features = await new Promise(resolve => {
                    setTimeout(() => {
                        if (vl.getSource().getFeatures().length === 0) {
                            return setTimeout(arguments.callee, 100);
                        }
                        resolve(vl.getSource().getFeatures());
                    });
                });
                for (let i in features) {
                    let feature = features[i];
                    featureMap[getCountryNameFromFeature(feature)] = feature;
                }

                let name;
                <xsl:for-each select="$countries/country[@name= $attacks/a/@country]">
                    name = "<xsl:value-of select="@name" />";
                    if (countryMap[name]) name = countryMap[name];
                    if (featureMap[name]) {
                        affectedOverlay.getSource().addFeature(featureMap[name]);
                    }
                    else console.warn("<xsl:value-of select="@name" />");
                </xsl:for-each>
            })();

            function getCountryNameFromFeature (f) {
                let name = f.getProperties().name;
                if (countryMap[name]) name = countryMap[name];
                return name;
            }

            function getAltCoutryName (n) {
                for (let i in countryMap) {
                    if (countryMap[i] === n) return i;
                }
                return n;
            }

            function selectCountry (c, changeMap = false, changeSelect = false) {
                <!-- console.log(c); -->
                window.location.hash = c;
                if (changeSelect) {
                    document.querySelectorAll('#countryList')[0].value = 
                        document.querySelectorAll(`#countryList option[value="${c}"]`).length === 0
                         ? getAltCoutryName(c)
                         : c;
                }

                if (changeMap) {
                    selectOverlay.getSource().clear();
                    let f = featureMap[c] ?? featureMap[countryMap[c]];
                    selectOverlay.getSource().addFeature(f);

                }

                let cnames = [c];
                for (let i in countryMap) {
                    if (countryMap[i] === c) {
                        cnames.push(i);
                    }
                }

                graph({country:cnames.join(',')});
            }

            function restoreCounts ()
            {
                document.querySelector('#killed').innerHTML = document.querySelector('#killed').getAttribute('data-count');
                document.querySelector('#injured').innerHTML = document.querySelector('#injured').getAttribute('data-count');
            }
            restoreCounts();
        </script>
    </body>
    </html>
</xsl:template>

</xsl:stylesheet>