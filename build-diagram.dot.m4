/*
Copyright 2018 Google LLC

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

define(style_SDK, `shape="box", fillcolor="#8e7cc3", style="filled"')
define(style_project, `shape="box", fillcolor="#6d9eeb", style="filled"')
define(style_anddep, `shape="box", fillcolor="#e06666", style="filled"')
define(style_javadep, `shape="box", fillcolor="#d387ff", style="filled"')
define(style_output, `shape="box", fillcolor="#ffd966", style="filled"')
define(style_plugin, `fillcolor="#f6b26b", style="filled"')
define(style_tools, `fillcolor="#93c47d", style="filled"')
define(style_jdk, `fillcolor="#c27ba0", style="filled"')
define(style_input, `arrowhead="ordot"')
define(style_opt_RS, `style="dashed", color="#4747DD"')
define(style_opt_NDK, `style="dashed", color="#47aa47"')
define(style_opt_signed, `style="dashed", color="#DD4747"')

digraph {
 /*style=invis*/
 /*splines=line;*/
 clusterrank="none"
 //newrank=true
 ranksep=1
 //splines=ortho
 
 graph [fontname = "Roboto", fontsize=16];
 node [fontname = "Roboto", fontsize=18, penwidth=3];
 edge [fontname = "Roboto", fontsize=16, penwidth=2];

 
 app_res -> res_merger [style_input]
 res -> res_merger [style_input]
 res_merger -> merged_res
 merged_res -> aapt [style_input]
 app_manifest -> manifest_merger [style_input]
 lib_manifest -> manifest_merger [style_input]
 manifest_merger -> merged_manifest
 merged_manifest -> aapt [style_input]
 lib_assets -> asset_merger [style_input]
 app_assets -> asset_merger [style_input]
 asset_merger -> merged_assets
 merged_assets -> aapt [style_input]
 ajar -> aapt [style_input]
 ajar -> javac [style_input]
 ajar -> proguard [style_input]
 rjava -> javac [style_input]
 aapt -> rjava
 ajc -> javac [style_input]
 jc -> javac [style_input]
 RSsl_jar -> javac [style_input, style_opt_RS]
 RSsl_jar -> proguard [style_input, style_opt_RS]
 aidlf -> aidl [style_input]
 aidl -> jc
 aidlf_lib -> aidl [style_input]
 framaidl -> aidl [style_input]
 javac -> cf
 cfijf -> proguard [style_input]
 cfijf -> javac [style_input]
 cfijf_lib -> proguard [style_input]
 cfijf_lib -> javac [style_input]
 rijf -> apkbuilder [style_input]
 rijf_lib -> apkbuilder [style_input]
 jr -> apkbuilder [style_input]
 cf -> proguard [style_input]
 proguard -> pgjar
 pgjar -> dex [style_input]
 dex -> cdex
 cdex -> apkbuilder [style_input]
 ajnic -> NDK [style_input, style_opt_NDK]
 NDKH -> NDK [style_input, style_opt_NDK]
 NDK -> sl [style_opt_NDK]
 sl -> apkbuilder [style_input, style_opt_NDK]
 sl_lib -> apkbuilder [style_input, style_opt_NDK]
 aapt -> cr
 cr-> apkbuilder [style_input]
 apkbuilder -> sapk [style_opt_signed]
 sapk -> zipalign [style_input] 
 zipalign -> saapk
 ks -> apkbuilder [style_input, style_opt_signed, constraint=false]
 ks -> apksigner [style_input]
 apkbuilder -> uapk
 uapk -> apksigner [style_input]
 apksigner -> sapk
 proguard -> pmap
 
 pgconf -> proguard [style_input]
 pgconf_aapt -> proguard [style_input]
 pgconf_lib -> proguard [style_input]
 aapt -> pgconf_aapt


// subgraph clusterAAPT {
     app_res [label="Application\nresources", style_project]
     res_merger [label="Resource\nmerger", style_plugin]
     res [label="Resources", style_anddep]
     app_manifest [label="Application\nmanifest", style_project]
     manifest_merger [label="Manifest\nmerger", style_plugin]
     lib_manifest [label="Manifest", style_anddep]
     lib_assets [label="Assets", style_anddep]
     app_assets [label="Application\nAssets", style_project]
     asset_merger [label="Asset\nmerger", style_plugin]
     merged_assets [label="Merged\nassets", style_output]
     merged_manifest [label="Merged\nmanifest", style_output]
     merged_res [label="Merged\nresources", style_output]
     aapt [label="aapt", style_tools]
     rjava [label="R.java", style_output]
// }
 subgraph clusterAIDL {
     label="AIDL"
     style="filled"
     fillcolor="#CCCCCC"
     penwidth=0
     aidlf [label=".aidl files", style_project]
     aidlf_lib [label=".aidl files", style_anddep]
     framaidl [label="framework.aidl", style_SDK]
     aidl [style_tools]
     jc [label="Java\nClasses", style_output]
 }
 

 /*pgconf [shape="record", label="{<p0> ProGuard configuration | <p1> ProGuard configuration | <p2> ProGuard configuration}"]*/
 
// subgraph clusterJavac {
     ajar [label="android.jar", style_SDK]
     javac [style_jdk]
     cf [label=".class files", style_output]
     
     jr [label="Java\nresources", style_project]
     cr [label="Compiled\nresources", style_output]
     cfijf [label=".class files\nin jar files", style_javadep]
     cfijf_lib [label=".class files\nin jar files", style_anddep]
     ajc [label="Application\nJava code", style_project]
//      subgraph clusterProguard { 
         proguard [style_plugin]
         pgjar[label="proguarded\njar", style_output]
         pgconf [label="ProGuard\nconfiguration", style_project]
         pgconf_aapt [label="ProGuard\nconfiguration", style_output]
         pgconf_lib [label="ProGuard\nconfiguration", style_anddep]          
//     }
 
     dex [style_tools]
     cdex [label="classes.dex", style_output]
// }
 
 subgraph clusterNative {
      label="NDK"
     style="filled"
     fillcolor="#CCEECC"
     penwidth=0
     sl [label=".so\nlibraries", style_output]
     NDK [style_tools]
     NDKH [label="NDK headers", style_SDK] 
     ajnic [label="Application\nJNI code", style_project]
     sl_lib [label=".so\nlibraries", style_anddep]
 }
// subgraph clusterPackaging {
//  label="Packaging"
//     style="filled"
//     fillcolor="#DDCCCC"
//     penwidth=0
     apkbuilder [style_plugin]
     ks [label="KeyStore"]
     apksigner [style_plugin, URL="https://developer.android.com/studio/command-line/apksigner.html"]
     uapk [label="Unsigned\nAPK", style_output]
     sapk [label="Signed\nAPK", style_output]
     zipalign [style_tools]
     saapk [label="Signed+Aligned\nAPK", style_output]
   rijf [label="resources in\njar files", style_javadep] 
  rijf_lib [label="resources in\njar files", style_anddep]
 //}
 pmap [label="Proguard\nMapping file", style_output]
 
 subgraph clusterRS {
  label="RenderScript"
     style="filled"
     fillcolor="#CCCCDD"
     penwidth=0
     RSh [label="RS\nheaders", style_SDK]
     RSf [label="RenderScript\nfiles", style_project]
     RSh_lib [label="RS\nheaders", style_anddep]
     llvm [label="llvm-rs-cc", style_tools]
     bcf [label="Bitcode\nfile", style_output]
     jc_rs [label="Java\nclasses", style_output]
     RSsl_bc [label="RS Support\nLibraries (bc)", style_SDK]
     RSsl_jar [label="RS Support\nLibraries (jar)", style_SDK]
     bccc [label="bcc\ncompat", style_tools]
     of [label=".o file", style_output]
     linker [style_tools]
     sl_rs [label=".so\nlibraries", style_output]
     RSsl_so [label="RS Support\nLibraries (so)", style_SDK]
     ccpp_rs [label="C/C++\nclasses", style_output]
 }
 
 RSh -> llvm [style_input]
 RSf -> llvm [style_input]
 RSh_lib -> llvm [style_input]
 llvm -> bcf
 llvm -> jc_rs
 jc_rs -> javac [style_input]
 bcf -> bccc [style_input, style_opt_RS]
 RSsl_bc -> bccc [style_input, style_opt_RS]
 bccc -> of [style_opt_RS]
 of -> linker [style_input, style_opt_RS]
 linker -> sl_rs [style_opt_RS]
 sl_rs -> apkbuilder [style_input, style_opt_RS]
 RSsl_so -> apkbuilder [style_input, style_opt_RS]
 llvm -> ccpp_rs [style_opt_NDK]
 ccpp_rs -> NDK [style_input, style_opt_NDK]
 bcf -> res_merger [style_input, constraint=false]

 { rank = same; saapk; pmap; }
 { rank = same; pgconf; pgconf_lib; pgconf_aapt }

 
}
