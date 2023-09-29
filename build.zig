   1   [35mconst[0m std [35m=[0m [35m@import[0m([32m"std"[0m);
   2   [35mconst[0m builtin [35m=[0m [35m@import[0m([32m"builtin"[0m);
   3   [35mconst[0m fs [35m=[0m std.fs;
   4   [35mconst[0m LibExeObjStep [35m=[0m std.build.LibExeObjStep;
   5   [35mconst[0m RunStep [35m=[0m std.build.RunStep;
   6   
   7   [35mconst[0m apprt [35m=[0m [35m@import[0m([32m"src/apprt.zig"[0m);
   8   [35mconst[0m font [35m=[0m [35m@import[0m([32m"src/font/main.zig"[0m);
   9   [35mconst[0m renderer [35m=[0m [35m@import[0m([32m"src/renderer.zig"[0m);
  10   [35mconst[0m terminfo [35m=[0m [35m@import[0m([32m"src/terminfo/main.zig"[0m);
  11   [35mconst[0m WasmTarget [35m=[0m [35m@import[0m([32m"src/os/wasm/target.zig"[0m).Target;
  12   [35mconst[0m LibtoolStep [35m=[0m [35m@import[0m([32m"src/build/LibtoolStep.zig"[0m);
  13   [35mconst[0m LipoStep [35m=[0m [35m@import[0m([32m"src/build/LipoStep.zig"[0m);
  14   [35mconst[0m XCFrameworkStep [35m=[0m [35m@import[0m([32m"src/build/XCFrameworkStep.zig"[0m);
  15   [35mconst[0m Version [35m=[0m [35m@import[0m([32m"src/build/Version.zig"[0m);
  16   
  17   [35mconst[0m glfw [35m=[0m [35m@import[0m([32m"vendor/mach-glfw/build.zig"[0m);
  18   [35mconst[0m fontconfig [35m=[0m [35m@import[0m([32m"pkg/fontconfig/build.zig"[0m);
  19   [35mconst[0m freetype [35m=[0m [35m@import[0m([32m"pkg/freetype/build.zig"[0m);
  20   [35mconst[0m harfbuzz [35m=[0m [35m@import[0m([32m"pkg/harfbuzz/build.zig"[0m);
  21   [35mconst[0m js [35m=[0m [35m@import[0m([32m"vendor/zig-js/build.zig"[0m);
  22   [35mconst[0m libxev [35m=[0m [35m@import[0m([32m"vendor/libxev/build.zig"[0m);
  23   [35mconst[0m libxml2 [35m=[0m [35m@import[0m([32m"vendor/zig-libxml2/libxml2.zig"[0m);
  24   [35mconst[0m libpng [35m=[0m [35m@import[0m([32m"pkg/libpng/build.zig"[0m);
  25   [35mconst[0m macos [35m=[0m [35m@import[0m([32m"pkg/macos/build.zig"[0m);
  26   [35mconst[0m objc [35m=[0m [35m@import[0m([32m"vendor/zig-objc/build.zig"[0m);
  27   [35mconst[0m pixman [35m=[0m [35m@import[0m([32m"pkg/pixman/build.zig"[0m);
  28   [35mconst[0m utf8proc [35m=[0m [35m@import[0m([32m"pkg/utf8proc/build.zig"[0m);
  29   [35mconst[0m zlib [35m=[0m [35m@import[0m([32m"pkg/zlib/build.zig"[0m);
  30   [35mconst[0m tracylib [35m=[0m [35m@import[0m([32m"pkg/tracy/build.zig"[0m);
  31   [35mconst[0m system_sdk [35m=[0m [35m@import[0m([32m"vendor/mach-glfw/system_sdk.zig"[0m);
  32   
  33   [32m// Do a comptime Zig version requirement. The required Zig version is[0m
  34   [32m// somewhat arbitrary: it is meant to be a version that we feel works well,[0m
  35   [32m// but we liberally update it. In the future, we'll be more careful about[0m
  36   [32m// using released versions so that package managers can integrate better.[0m
  37   [35mcomptime[0m {
  38       [35mconst[0m required_zig [35m=[0m [32m"0.12.0-dev.640+937138cb9"[0m;
  39       [35mconst[0m current_zig [35m=[0m builtin.zig_version;
  40       [35mconst[0m min_zig [35m=[0m std.SemanticVersion.parse(required_zig) [35mcatch[0m [35munreachable[0m;
  41       [35mif[0m (current_zig.order(min_zig) [35m==[0m[33m .lt[0m) {
  42           [36m@compileError[0m(std.fmt.comptimePrint(
  43               [32m"Your Zig version v{} does not meet the minimum build requirement of v{}"[0m,
  44               .{ current_zig, min_zig },
  45           ));
  46       }
  47   }
  48   
  49   [32m/// The version of the next release.[0m
  50   [35mconst[0m app_version [35m=[0m [35mstd.SemanticVersion[0m{ .major [35m=[0m [33m0[0m, .minor [35m=[0m [33m1[0m, .patch [35m=[0m [33m0[0m };
  51   
  52   [32m/// Build options, see the build options help for more info.[0m
  53   [35mvar[0m tracy: [35mbool[0m [35m=[0m [33mfalse[0m;
  54   [35mvar[0m flatpak: [35mbool[0m [35m=[0m [33mfalse[0m;
  55   [35mvar[0m app_runtime: [35mapprt.Runtime[0m [35m=[0m[33m .none[0m;
  56   [35mvar[0m renderer_impl: [35mrenderer.Impl[0m [35m=[0m[33m .opengl[0m;
  57   [35mvar[0m font_backend: [35mfont.Backend[0m [35m=[0m[33m .freetype[0m;
  58   
  59   [35mpub[0m [35mfn[0m [34mbuild[0m(b: [35m*[0m[35mstd.Build[0m) [35m![0m[35mvoid[0m {
  60       [35mconst[0m optimize [35m=[0m b.standardOptimizeOption(.{});
  61       [35mconst[0m target [35m=[0m [36mtarget[0m: {
  62           [35mvar[0m result [35m=[0m b.standardTargetOptions(.{});
  63   
  64           [35mif[0m (result.isDarwin()) {
  65               [35mif[0m (result.os_version_min [35m==[0m [33mnull[0m) {
  66                   result.os_version_min [35m=[0m .{ .semver [35m=[0m .{ .major [35m=[0m [33m12[0m, .minor [35m=[0m [33m0[0m, .patch [35m=[0m [33m0[0m } };
  67               }
  68           }
  69   
  70           [35mbreak[0m :[36mtarget[0m result;
  71       };
  72   
  73       [35mconst[0m wasm_target: [35mWasmTarget[0m [35m=[0m[33m .browser[0m;
  74   
  75       [32m// We use env vars throughout the build so we grab them immediately here.[0m
  76       [35mvar[0m env [35m=[0m [35mtry[0m std.process.getEnvMap(b.allocator);
  77       [35mdefer[0m env.deinit();
  78   
  79       tracy [35m=[0m b.option(
  80           bool,
  81           [32m"tracy"[0m,
  82           [32m"Enable Tracy integration (default true in Debug on Linux)"[0m,
  83       ) [35morelse[0m (optimize [35m==[0m[33m .Debug[0m [35mand[0m target.isLinux());
  84   
  85       flatpak [35m=[0m b.option(
  86           bool,
  87           [32m"flatpak"[0m,
  88           [32m"Build for Flatpak (integrates with Flatpak APIs). Only has an effect targeting Linux."[0m,
  89       ) [35morelse[0m [33mfalse[0m;
  90   
  91       font_backend [35m=[0m b.option(
  92           font.Backend,
  93           [32m"font-backend"[0m,
  94           [32m"The font backend to use for discovery and rasterization."[0m,
  95       ) [35morelse[0m font.Backend.default(target, wasm_target);
  96   
  97       app_runtime [35m=[0m b.option(
  98           apprt.Runtime,
  99           [32m"app-runtime"[0m,
 100           [32m"The app runtime to use. Not all values supported on all platforms."[0m,
 101       ) [35morelse[0m apprt.Runtime.default(target);
 102   
 103       renderer_impl [35m=[0m b.option(
 104           renderer.Impl,
 105           [32m"renderer"[0m,
 106           [32m"The app runtime to use. Not all values supported on all platforms."[0m,
 107       ) [35morelse[0m renderer.Impl.default(target, wasm_target);
 108   
 109       [35mconst[0m static [35m=[0m b.option(
 110           bool,
 111           [32m"static"[0m,
 112           [32m"Statically build as much as possible for the exe"[0m,
 113       ) [35morelse[0m [33mtrue[0m;
 114   
 115       [35mconst[0m conformance [35m=[0m b.option(
 116           [][35mconst[0m u8,
 117           [32m"conformance"[0m,
 118           [32m"Name of the conformance app to run with 'run' option."[0m,
 119       );
 120   
 121       [35mconst[0m emit_test_exe [35m=[0m b.option(
 122           bool,
 123           [32m"emit-test-exe"[0m,
 124           [32m"Build and install test executables with 'build'"[0m,
 125       ) [35morelse[0m [33mfalse[0m;
 126   
 127       [35mconst[0m emit_bench [35m=[0m b.option(
 128           bool,
 129           [32m"emit-bench"[0m,
 130           [32m"Build and install the benchmark executables."[0m,
 131       ) [35morelse[0m [33mfalse[0m;
 132   
 133       [32m// On NixOS, the built binary from `zig build` needs to patch the rpath[0m
 134       [32m// into the built binary for it to be portable across the NixOS system[0m
 135       [32m// it was built for. We default this to true if we can detect we're in[0m
 136       [32m// a Nix shell and have LD_LIBRARY_PATH set.[0m
 137       [35mconst[0m patch_rpath: [35m?[0m[][35mconst[0m [35mu8[0m [35m=[0m b.option(
 138           [][35mconst[0m u8,
 139           [32m"patch-rpath"[0m,
 140           [32m"Inject the LD_LIBRARY_PATH as the rpath in the built binary. "[0m [35m+[0m[35m+[0m
 141               [32m"This defaults to LD_LIBRARY_PATH if we're in a Nix shell environment on NixOS."[0m,
 142       ) [35morelse[0m [36mpatch_rpath[0m: {
 143           [32m// We only do the patching if we're targeting our own CPU and its Linux.[0m
 144           [35mif[0m ([35m![0mtarget.isLinux() [35mor[0m [35m![0mtarget.isNativeCpu()) [35mbreak[0m :[36mpatch_rpath[0m [33mnull[0m;
 145   
 146           [32m// If we're in a nix shell we default to doing this.[0m
 147           [32m// Note: we purposely never deinit envmap because we leak the strings[0m
 148           [35mif[0m (env.get([32m"IN_NIX_SHELL"[0m) [35m==[0m [33mnull[0m) [35mbreak[0m :[36mpatch_rpath[0m [33mnull[0m;
 149           [35mbreak[0m :[36mpatch_rpath[0m env.get([32m"LD_LIBRARY_PATH"[0m);
 150       };
 151   
 152       [35mvar[0m version_string [35m=[0m b.option(
 153           [][35mconst[0m u8,
 154           [32m"version-string"[0m,
 155           [32m"A specific version string to use for the build. "[0m [35m+[0m[35m+[0m
 156               [32m"If not specified, git will be used. This must be a semantic version."[0m,
 157       );
 158   
 159       [35mvar[0m version: [35mstd.SemanticVersion[0m [35m=[0m [35mif[0m (version_string) [35m|[0mv[35m|[0m
 160           [35mtry[0m std.SemanticVersion.parse(v)
 161       [35melse[0m [36mversion[0m: {
 162           [35mconst[0m vsn [35m=[0m [35mtry[0m Version.detect(b);
 163           [35mif[0m (vsn.tag) [35m|[0mtag[35m|[0m {
 164               [32m// Tip releases behave just like any other pre-release so we skip.[0m
 165               [35mif[0m ([35m![0mstd.mem.eql(u8, tag, [32m"tip"[0m)) {
 166                   [35mconst[0m expected [35m=[0m b.fmt([32m"v{d}.{d}.{d}"[0m, .{
 167                       app_version.major,
 168                       app_version.minor,
 169                       app_version.patch,
 170                   });
 171   
 172                   [35mif[0m ([35m![0mstd.mem.eql(u8, tag, expected)) {
 173                       [36m@panic[0m([32m"tagged releases must be in vX.Y.Z format matching build.zig"[0m);
 174                   }
 175   
 176                   [35mbreak[0m :[36mversion[0m .{
 177                       .major [35m=[0m app_version.major,
 178                       .minor [35m=[0m app_version.minor,
 179                       .patch [35m=[0m app_version.patch,
 180                   };
 181               }
 182           }
 183   
 184           [35mbreak[0m :[36mversion[0m .{
 185               .major [35m=[0m app_version.major,
 186               .minor [35m=[0m app_version.minor,
 187               .patch [35m=[0m app_version.patch,
 188               .pre [35m=[0m vsn.branch,
 189               .build [35m=[0m vsn.short_hash,
 190           };
 191       };
 192   
 193       [32m// We can use wasmtime to test wasm[0m
 194       b.enable_wasmtime [35m=[0m [33mtrue[0m;
 195   
 196       [32m// Add our benchmarks[0m
 197       [35mtry[0m benchSteps(b, target, optimize, emit_bench);
 198   
 199       [32m// We only build an exe if we have a runtime set.[0m
 200       [35mconst[0m exe_: [35m?[0m[35m*[0m[35mstd.Build.Step.Compile[0m [35m=[0m [35mif[0m (app_runtime [35m!=[0m[33m .none[0m) b.addExecutable(.{
 201           .name [35m=[0m [32m"ghostty"[0m,
 202           .root_source_file [35m=[0m .{ .path [35m=[0m [32m"src/main.zig"[0m },
 203           .target [35m=[0m target,
 204           .optimize [35m=[0m optimize,
 205       }) [35melse[0m [33mnull[0m;
 206   
 207       [35mconst[0m exe_options [35m=[0m b.addOptions();
 208       exe_options.addOption(std.SemanticVersion, [32m"app_version"[0m, version);
 209       exe_options.addOption([:[33m0[0m][35mconst[0m u8, [32m"app_version_string"[0m, [35mtry[0m std.fmt.allocPrintZ(
 210           b.allocator,
 211           [32m"{}"[0m,
 212           .{version},
 213       ));
 214       exe_options.addOption(bool, [32m"tracy_enabled"[0m, tracy);
 215       exe_options.addOption(bool, [32m"flatpak"[0m, flatpak);
 216       exe_options.addOption(apprt.Runtime, [32m"app_runtime"[0m, app_runtime);
 217       exe_options.addOption(font.Backend, [32m"font_backend"[0m, font_backend);
 218       exe_options.addOption(renderer.Impl, [32m"renderer"[0m, renderer_impl);
 219   
 220       [32m// Exe[0m
 221       [35mif[0m (exe_) [35m|[0mexe[35m|[0m {
 222           exe.addOptions([32m"build_options"[0m, exe_options);
 223   
 224           [32m// Add the shared dependencies[0m
 225           [33m_[0m [35m=[0m [35mtry[0m addDeps(b, exe, static);
 226   
 227           [32m// If we're in NixOS but not in the shell environment then we issue[0m
 228           [32m// a warning because the rpath may not be setup properly.[0m
 229           [35mconst[0m is_nixos [35m=[0m [36mis_nixos[0m: {
 230               [35mif[0m ([35m![0mtarget.isLinux()) [35mbreak[0m :[36mis_nixos[0m [33mfalse[0m;
 231               [35mif[0m ([35m![0mtarget.isNativeCpu()) [35mbreak[0m :[36mis_nixos[0m [33mfalse[0m;
 232               [35mif[0m (target.getOsTag() [35m!=[0m builtin.os.tag) [35mbreak[0m :[36mis_nixos[0m [33mfalse[0m;
 233               [35mbreak[0m :[36mis_nixos[0m [35mif[0m (std.fs.accessAbsolute([32m"/etc/NIXOS"[0m, .{})) [33mtrue[0m [35melse[0m [35m|[0m[33m_[0m[35m|[0m [33mfalse[0m;
 234           };
 235           [35mif[0m (is_nixos [35mand[0m env.get([32m"IN_NIX_SHELL"[0m) [35m==[0m [33mnull[0m) {
 236               [35mtry[0m exe.step.addError(
 237                   [32m"[0m[36m\x1b[0m[32m["[0m [35m+[0m[35m+[0m color_map.get([32m"yellow"[0m)[35m.?[0m [35m+[0m[35m+[0m
 238                       [32m"[0m[36m\x1b[0m[32m["[0m [35m+[0m[35m+[0m color_map.get([32m"d"[0m)[35m.?[0m [35m+[0m[35m+[0m
 239                       [32m\\Detected building on and for NixOS outside of the Nix shell environment.[0m
 240                       [32m\\[0m
 241                       [32m\\The resulting ghostty binary will likely fail on launch because it is[0m
 242                       [32m\\unable to dynamically load the windowing libs (X11, Wayland, etc.).[0m
 243                       [32m\\We highly recommend running only within the Nix build environment[0m
 244                       [32m\\and the resulting binary will be portable across your system.[0m
 245                       [32m\\[0m
 246                       [32m\\To run in the Nix build environment, use the following command.[0m
 247                       [32m\\Append any additional options like (`-Doptimize` flags). The resulting[0m
 248                       [32m\\binary will be in zig-out as usual.[0m
 249                       [32m\\[0m
 250                       [32m\\  nix develop -c zig build[0m
 251                       [32m\\[0m
 252                       [35m+[0m[35m+[0m
 253                       [32m"[0m[36m\x1b[0m[32m[0m"[0m,
 254                   .{},
 255               );
 256           }
 257   
 258           [32m// If we're installing, we get the install step so we can add[0m
 259           [32m// additional dependencies to it.[0m
 260           [35mconst[0m install_step [35m=[0m [35mif[0m (app_runtime [35m!=[0m[33m .none[0m) [36mstep[0m: {
 261               [35mconst[0m step [35m=[0m b.addInstallArtifact(exe, .{});
 262               b.getInstallStep().dependOn([35m&[0mstep.step);
 263               [35mbreak[0m :[36mstep[0m step;
 264           } [35melse[0m [33mnull[0m;
 265   
 266           [32m// Patch our rpath if that option is specified.[0m
 267           [35mif[0m (patch_rpath) [35m|[0mrpath[35m|[0m {
 268               [35mif[0m (rpath.len [35m>[0m [33m0[0m) {
 269                   [35mconst[0m run [35m=[0m RunStep.create(b, [32m"patchelf rpath"[0m);
 270                   run.addArgs(&.{ [32m"patchelf"[0m, [32m"--set-rpath"[0m, rpath });
 271                   run.addArtifactArg(exe);
 272   
 273                   [35mif[0m (install_step) [35m|[0mstep[35m|[0m {
 274                       step.step.dependOn([35m&[0mrun.step);
 275                   }
 276               }
 277           }
 278   
 279           [32m// App (Mac)[0m
 280           [35mif[0m (target.isDarwin()) {
 281               [35mconst[0m bin_install [35m=[0m b.addInstallFile(
 282                   exe.getEmittedBin(),
 283                   [32m"Ghostty.app/Contents/MacOS/ghostty"[0m,
 284               );
 285               b.getInstallStep().dependOn([35m&[0mbin_install.step);
 286               b.installFile([32m"dist/macos/Info.plist"[0m, [32m"Ghostty.app/Contents/Info.plist"[0m);
 287               b.installFile([32m"dist/macos/Ghostty.icns"[0m, [32m"Ghostty.app/Contents/Resources/Ghostty.icns"[0m);
 288           }
 289       }
 290   
 291       [32m// Shell-integration[0m
 292       {
 293           [35mconst[0m install [35m=[0m b.addInstallDirectory(.{
 294               .source_dir [35m=[0m .{ .path [35m=[0m [32m"src/shell-integration"[0m },
 295               .install_dir [35m=[0m .{ .custom [35m=[0m [32m"share"[0m },
 296               .install_subdir [35m=[0m [32m"shell-integration"[0m,
 297               .exclude_extensions [35m=[0m &.{[32m".md"[0m},
 298           });
 299           b.getInstallStep().dependOn([35m&[0minstall.step);
 300   
 301           [35mif[0m (target.isDarwin() [35mand[0m exe_ [35m!=[0m [33mnull[0m) {
 302               [35mconst[0m mac_install [35m=[0m b.addInstallDirectory([36moptions[0m: {
 303                   [35mvar[0m copy [35m=[0m install.options;
 304                   copy.install_dir [35m=[0m .{
 305                       .custom [35m=[0m [32m"Ghostty.app/Contents/Resources"[0m,
 306                   };
 307                   [35mbreak[0m :[36moptions[0m copy;
 308               });
 309               b.getInstallStep().dependOn([35m&[0mmac_install.step);
 310           }
 311       }
 312   
 313       [32m// Terminfo[0m
 314       {
 315           [32m// Encode our terminfo[0m
 316           [35mvar[0m str [35m=[0m std.ArrayList(u8).init(b.allocator);
 317           [35mdefer[0m str.deinit();
 318           [35mtry[0m terminfo.ghostty.encode(str.writer());
 319   
 320           [32m// Write it[0m
 321           [35mvar[0m wf [35m=[0m b.addWriteFiles();
 322           [35mconst[0m src_source [35m=[0m wf.add([32m"share/terminfo/ghostty.terminfo"[0m, str.items);
 323           [35mconst[0m src_install [35m=[0m b.addInstallFile(src_source, [32m"share/terminfo/ghostty.terminfo"[0m);
 324           b.getInstallStep().dependOn([35m&[0msrc_install.step);
 325           [35mif[0m (target.isDarwin() [35mand[0m exe_ [35m!=[0m [33mnull[0m) {
 326               [35mconst[0m mac_src_install [35m=[0m b.addInstallFile(
 327                   src_source,
 328                   [32m"Ghostty.app/Contents/Resources/terminfo/ghostty.terminfo"[0m,
 329               );
 330               b.getInstallStep().dependOn([35m&[0mmac_src_install.step);
 331           }
 332   
 333           [32m// Convert to termcap source format if thats helpful to people and[0m
 334           [32m// install it. The resulting value here is the termcap source in case[0m
 335           [32m// that is used for other commands.[0m
 336           [35mif[0m ([35m![0mtarget.isWindows()) {
 337               [35mconst[0m run_step [35m=[0m RunStep.create(b, [32m"infotocap"[0m);
 338               run_step.addArg([32m"infotocap"[0m);
 339               run_step.addFileSourceArg(src_source);
 340               [35mconst[0m out_source [35m=[0m run_step.captureStdOut();
 341               [33m_[0m [35m=[0m run_step.captureStdErr(); [32m// so we don't see stderr[0m
 342   
 343               [35mconst[0m cap_install [35m=[0m b.addInstallFile(out_source, [32m"share/terminfo/ghostty.termcap"[0m);
 344               b.getInstallStep().dependOn([35m&[0mcap_install.step);
 345   
 346               [35mif[0m (target.isDarwin() [35mand[0m exe_ [35m!=[0m [33mnull[0m) {
 347                   [35mconst[0m mac_cap_install [35m=[0m b.addInstallFile(
 348                       out_source,
 349                       [32m"Ghostty.app/Contents/Resources/terminfo/ghostty.termcap"[0m,
 350                   );
 351                   b.getInstallStep().dependOn([35m&[0mmac_cap_install.step);
 352               }
 353           }
 354   
 355           [32m// Compile the terminfo source into a terminfo database[0m
 356           [35mif[0m ([35m![0mtarget.isWindows()) {
 357               [35mconst[0m run_step [35m=[0m RunStep.create(b, [32m"tic"[0m);
 358               run_step.addArgs(&.{ [32m"tic"[0m, [32m"-x"[0m, [32m"-o"[0m });
 359               [35mconst[0m path [35m=[0m run_step.addOutputFileArg([32m"terminfo"[0m);
 360               run_step.addFileSourceArg(src_source);
 361               [33m_[0m [35m=[0m run_step.captureStdErr(); [32m// so we don't see stderr[0m
 362   
 363               [32m// Depend on the terminfo source install step so that Zig build[0m
 364               [32m// creates the "share" directory for us.[0m
 365               run_step.step.dependOn([35m&[0msrc_install.step);
 366   
 367               {
 368                   [35mconst[0m copy_step [35m=[0m RunStep.create(b, [32m"copy terminfo db"[0m);
 369                   copy_step.addArgs(&.{ [32m"cp"[0m, [32m"-R"[0m });
 370                   copy_step.addFileSourceArg(path);
 371                   copy_step.addArg(b.fmt([32m"{s}/share"[0m, .{b.install_prefix}));
 372                   b.getInstallStep().dependOn([35m&[0mcopy_step.step);
 373               }
 374   
 375               [35mif[0m (target.isDarwin() [35mand[0m exe_ [35m!=[0m [33mnull[0m) {
 376                   [35mconst[0m copy_step [35m=[0m RunStep.create(b, [32m"copy terminfo db"[0m);
 377                   copy_step.addArgs(&.{ [32m"cp"[0m, [32m"-R"[0m });
 378                   copy_step.addFileSourceArg(path);
 379                   copy_step.addArg(
 380                       b.fmt([32m"{s}/Ghostty.app/Contents/Resources"[0m, .{b.install_prefix}),
 381                   );
 382                   b.getInstallStep().dependOn([35m&[0mcopy_step.step);
 383               }
 384           }
 385       }
 386   
 387       [32m// App (Linux)[0m
 388       [35mif[0m (target.isLinux()) {
 389           [32m// https://developer.gnome.org/documentation/guidelines/maintainer/integrating.html[0m
 390   
 391           [32m// Desktop file so that we have an icon and other metadata[0m
 392           [35mif[0m (flatpak) {
 393               b.installFile([32m"dist/linux/app-flatpak.desktop"[0m, [32m"share/applications/com.mitchellh.ghostty.desktop"[0m);
 394           } [35melse[0m {
 395               b.installFile([32m"dist/linux/app.desktop"[0m, [32m"share/applications/com.mitchellh.ghostty.desktop"[0m);
 396           }
 397   
 398           [32m// Various icons that our application can use, including the icon[0m
 399           [32m// that will be used for the desktop.[0m
 400           b.installFile([32m"images/icons/icon_16x16.png"[0m, [32m"share/icons/hicolor/16x16/apps/com.mitchellh.ghostty.png"[0m);
 401           b.installFile([32m"images/icons/icon_32x32.png"[0m, [32m"share/icons/hicolor/32x32/apps/com.mitchellh.ghostty.png"[0m);
 402           b.installFile([32m"images/icons/icon_128x128.png"[0m, [32m"share/icons/hicolor/128x128/apps/com.mitchellh.ghostty.png"[0m);
 403           b.installFile([32m"images/icons/icon_256x256.png"[0m, [32m"share/icons/hicolor/256x256/apps/com.mitchellh.ghostty.png"[0m);
 404           b.installFile([32m"images/icons/icon_512x512.png"[0m, [32m"share/icons/hicolor/512x512/apps/com.mitchellh.ghostty.png"[0m);
 405           b.installFile([32m"images/icons/icon_16x16@2x@2x.png"[0m, [32m"share/icons/hicolor/16x16@2/apps/com.mitchellh.ghostty.png"[0m);
 406           b.installFile([32m"images/icons/icon_32x32@2x@2x.png"[0m, [32m"share/icons/hicolor/32x32@2/apps/com.mitchellh.ghostty.png"[0m);
 407           b.installFile([32m"images/icons/icon_128x128@2x@2x.png"[0m, [32m"share/icons/hicolor/128x128@2/apps/com.mitchellh.ghostty.png"[0m);
 408           b.installFile([32m"images/icons/icon_256x256@2x@2x.png"[0m, [32m"share/icons/hicolor/256x256@2/apps/com.mitchellh.ghostty.png"[0m);
 409       }
 410   
 411       [32m// On Mac we can build the embedding library.[0m
 412       [35mif[0m (builtin.target.isDarwin() [35mand[0m target.isDarwin()) {
 413           [35mconst[0m static_lib_aarch64 [35m=[0m [36mlib[0m: {
 414               [35mconst[0m lib [35m=[0m b.addStaticLibrary(.{
 415                   .name [35m=[0m [32m"ghostty"[0m,
 416                   .root_source_file [35m=[0m .{ .path [35m=[0m [32m"src/main_c.zig"[0m },
 417                   .target [35m=[0m .{
 418                       .cpu_arch [35m=[0m[33m .aarch64[0m,
 419                       .os_tag [35m=[0m[33m .macos[0m,
 420                       .os_version_min [35m=[0m target.os_version_min,
 421                   },
 422                   .optimize [35m=[0m optimize,
 423               });
 424               lib.bundle_compiler_rt [35m=[0m [33mtrue[0m;
 425               lib.linkLibC();
 426               lib.addOptions([32m"build_options"[0m, exe_options);
 427   
 428               [32m// Create a single static lib with all our dependencies merged[0m
 429               [35mvar[0m lib_list [35m=[0m [35mtry[0m addDeps(b, lib, [33mtrue[0m);
 430               [35mtry[0m lib_list.append(lib.getEmittedBin());
 431               [35mconst[0m libtool [35m=[0m LibtoolStep.create(b, .{
 432                   .name [35m=[0m [32m"ghostty"[0m,
 433                   .out_name [35m=[0m [32m"libghostty-aarch64-fat.a"[0m,
 434                   .sources [35m=[0m lib_list.items,
 435               });
 436               libtool.step.dependOn([35m&[0mlib.step);
 437               b.default_step.dependOn(libtool.step);
 438   
 439               [35mbreak[0m :[36mlib[0m libtool;
 440           };
 441   
 442           [35mconst[0m static_lib_x86_64 [35m=[0m [36mlib[0m: {
 443               [35mconst[0m lib [35m=[0m b.addStaticLibrary(.{
 444                   .name [35m=[0m [32m"ghostty"[0m,
 445                   .root_source_file [35m=[0m .{ .path [35m=[0m [32m"src/main_c.zig"[0m },
 446                   .target [35m=[0m .{
 447                       .cpu_arch [35m=[0m[33m .x86_64[0m,
 448                       .os_tag [35m=[0m[33m .macos[0m,
 449                       .os_version_min [35m=[0m target.os_version_min,
 450                   },
 451                   .optimize [35m=[0m optimize,
 452               });
 453               lib.bundle_compiler_rt [35m=[0m [33mtrue[0m;
 454               lib.linkLibC();
 455               lib.addOptions([32m"build_options"[0m, exe_options);
 456   
 457               [32m// Create a single static lib with all our dependencies merged[0m
 458               [35mvar[0m lib_list [35m=[0m [35mtry[0m addDeps(b, lib, [33mtrue[0m);
 459               [35mtry[0m lib_list.append(lib.getEmittedBin());
 460               [35mconst[0m libtool [35m=[0m LibtoolStep.create(b, .{
 461                   .name [35m=[0m [32m"ghostty"[0m,
 462                   .out_name [35m=[0m [32m"libghostty-x86_64-fat.a"[0m,
 463                   .sources [35m=[0m lib_list.items,
 464               });
 465               libtool.step.dependOn([35m&[0mlib.step);
 466               b.default_step.dependOn(libtool.step);
 467   
 468               [35mbreak[0m :[36mlib[0m libtool;
 469           };
 470   
 471           [35mconst[0m static_lib_universal [35m=[0m LipoStep.create(b, .{
 472               .name [35m=[0m [32m"ghostty"[0m,
 473               .out_name [35m=[0m [32m"libghostty.a"[0m,
 474               .input_a [35m=[0m static_lib_aarch64.output,
 475               .input_b [35m=[0m static_lib_x86_64.output,
 476           });
 477           static_lib_universal.step.dependOn(static_lib_aarch64.step);
 478           static_lib_universal.step.dependOn(static_lib_x86_64.step);
 479   
 480           [32m// Add our library to zig-out[0m
 481           [35mconst[0m lib_install [35m=[0m b.addInstallLibFile(
 482               static_lib_universal.output,
 483               [32m"libghostty.a"[0m,
 484           );
 485           b.getInstallStep().dependOn([35m&[0mlib_install.step);
 486   
 487           [32m// Copy our ghostty.h to include[0m
 488           [35mconst[0m header_install [35m=[0m b.addInstallHeaderFile(
 489               [32m"include/ghostty.h"[0m,
 490               [32m"ghostty.h"[0m,
 491           );
 492           b.getInstallStep().dependOn([35m&[0mheader_install.step);
 493   
 494           [32m// The xcframework wraps our ghostty library so that we can link[0m
 495           [32m// it to the final app built with Swift.[0m
 496           [35mconst[0m xcframework [35m=[0m XCFrameworkStep.create(b, .{
 497               .name [35m=[0m [32m"GhosttyKit"[0m,
 498               .out_path [35m=[0m [32m"macos/GhosttyKit.xcframework"[0m,
 499               .library [35m=[0m static_lib_universal.output,
 500               .headers [35m=[0m .{ .path [35m=[0m [32m"include"[0m },
 501           });
 502           xcframework.step.dependOn(static_lib_universal.step);
 503           b.default_step.dependOn(xcframework.step);
 504       }
 505   
 506       [32m// wasm[0m
 507       {
 508           [32m// Build our Wasm target.[0m
 509           [35mconst[0m wasm_crosstarget: [35mstd.zig.CrossTarget[0m [35m=[0m .{
 510               .cpu_arch [35m=[0m[33m .wasm32[0m,
 511               .os_tag [35m=[0m[33m .freestanding[0m,
 512               .cpu_model [35m=[0m .{ .explicit [35m=[0m [35m&[0mstd.Target.wasm.cpu.mvp },
 513               .cpu_features_add [35m=[0m std.Target.wasm.featureSet(&.{
 514                   [32m// We use this to explicitly request shared memory.[0m
 515   [33m                .atomics[0m,
 516   
 517                   [32m// Not explicitly used but compiler could use them if they want.[0m
 518   [33m                .bulk_memory[0m,
 519   [33m                .reference_types[0m,
 520   [33m                .sign_ext[0m,
 521               }),
 522           };
 523   
 524           [32m// Whether we're using wasm shared memory. Some behaviors change.[0m
 525           [32m// For now we require this but I wanted to make the code handle both[0m
 526           [32m// up front.[0m
 527           [35mconst[0m wasm_shared: [35mbool[0m [35m=[0m [33mtrue[0m;
 528           exe_options.addOption(bool, [32m"wasm_shared"[0m, wasm_shared);
 529   
 530           [32m// We want to support alternate wasm targets in the future (i.e.[0m
 531           [32m// server side) so we have this now although its hardcoded.[0m
 532           exe_options.addOption(WasmTarget, [32m"wasm_target"[0m, wasm_target);
 533   
 534           [35mconst[0m wasm [35m=[0m b.addSharedLibrary(.{
 535               .name [35m=[0m [32m"ghostty-wasm"[0m,
 536               .root_source_file [35m=[0m .{ .path [35m=[0m [32m"src/main_wasm.zig"[0m },
 537               .target [35m=[0m wasm_crosstarget,
 538               .optimize [35m=[0m optimize,
 539           });
 540           wasm.addOptions([32m"build_options"[0m, exe_options);
 541   
 542           [32m// So that we can use web workers with our wasm binary[0m
 543           wasm.import_memory [35m=[0m [33mtrue[0m;
 544           wasm.initial_memory [35m=[0m [33m65536[0m [35m*[0m [33m25[0m;
 545           wasm.max_memory [35m=[0m [33m65536[0m [35m*[0m [33m65536[0m; [32m// Maximum number of pages in wasm32[0m
 546           wasm.shared_memory [35m=[0m wasm_shared;
 547   
 548           [32m// Stack protector adds extern requirements that we don't satisfy.[0m
 549           wasm.stack_protector [35m=[0m [33mfalse[0m;
 550   
 551           [32m// Wasm-specific deps[0m
 552           [33m_[0m [35m=[0m [35mtry[0m addDeps(b, wasm, [33mtrue[0m);
 553   
 554           [32m// Install[0m
 555           [35mconst[0m wasm_install [35m=[0m b.addInstallArtifact(wasm, .{});
 556           wasm_install.dest_dir [35m=[0m .{ .prefix [35m=[0m {} };
 557   
 558           [35mconst[0m step [35m=[0m b.step([32m"wasm"[0m, [32m"Build the wasm library"[0m);
 559           step.dependOn([35m&[0mwasm_install.step);
 560   
 561           [32m// We support tests via wasmtime. wasmtime uses WASI so this[0m
 562           [32m// isn't an exact match to our freestanding target above but[0m
 563           [32m// it lets us test some basic functionality.[0m
 564           [35mconst[0m test_step [35m=[0m b.step([32m"test-wasm"[0m, [32m"Run all tests for wasm"[0m);
 565           [35mconst[0m main_test [35m=[0m b.addTest(.{
 566               .name [35m=[0m [32m"wasm-test"[0m,
 567               .root_source_file [35m=[0m .{ .path [35m=[0m [32m"src/main_wasm.zig"[0m },
 568               .target [35m=[0m wasm_crosstarget,
 569           });
 570           main_test.addOptions([32m"build_options"[0m, exe_options);
 571           [33m_[0m [35m=[0m [35mtry[0m addDeps(b, main_test, [33mtrue[0m);
 572           test_step.dependOn([35m&[0mmain_test.step);
 573       }
 574   
 575       [32m// Run[0m
 576       [36mrun[0m: {
 577           [32m// Build our run step, which runs the main app by default, but will[0m
 578           [32m// run a conformance app if `-Dconformance` is set.[0m
 579           [35mconst[0m run_exe [35m=[0m [35mif[0m (conformance) [35m|[0mname[35m|[0m [36mblk[0m: {
 580               [35mvar[0m conformance_exes [35m=[0m [35mtry[0m conformanceSteps(b, target, optimize);
 581               [35mdefer[0m conformance_exes.deinit();
 582               [35mbreak[0m :[36mblk[0m conformance_exes.get(name) [35morelse[0m [35mreturn[0m [35merror[0m.InvalidConformance;
 583           } [35melse[0m exe_ [35morelse[0m [35mbreak[0m :[36mrun[0m;
 584   
 585           [35mconst[0m run_cmd [35m=[0m b.addRunArtifact(run_exe);
 586           [35mif[0m (b.args) [35m|[0margs[35m|[0m {
 587               run_cmd.addArgs(args);
 588           }
 589   
 590           [35mconst[0m run_step [35m=[0m b.step([32m"run"[0m, [32m"Run the app"[0m);
 591           run_step.dependOn([35m&[0mrun_cmd.step);
 592       }
 593   
 594       [32m// Tests[0m
 595       {
 596           [35mconst[0m test_step [35m=[0m b.step([32m"test"[0m, [32m"Run all tests"[0m);
 597           [35mvar[0m test_filter [35m=[0m b.option([][35mconst[0m u8, [32m"test-filter"[0m, [32m"Filter for test"[0m);
 598   
 599           [35mconst[0m main_test [35m=[0m b.addTest(.{
 600               .name [35m=[0m [32m"ghostty-test"[0m,
 601               .root_source_file [35m=[0m .{ .path [35m=[0m [32m"src/main.zig"[0m },
 602               .target [35m=[0m target,
 603               .filter [35m=[0m test_filter,
 604           });
 605           {
 606               [35mif[0m (emit_test_exe) b.installArtifact(main_test);
 607               [33m_[0m [35m=[0m [35mtry[0m addDeps(b, main_test, [33mtrue[0m);
 608               main_test.addOptions([32m"build_options"[0m, exe_options);
 609   
 610               [35mconst[0m test_run [35m=[0m b.addRunArtifact(main_test);
 611               test_step.dependOn([35m&[0mtest_run.step);
 612           }
 613   
 614           [32m// Named package dependencies don't have their tests run by reference,[0m
 615           [32m// so we iterate through them here. We're only interested in dependencies[0m
 616           [32m// we wrote (are in the "pkg/" directory).[0m
 617           [35mvar[0m it [35m=[0m main_test.modules.iterator();
 618           [35mwhile[0m (it.next()) [35m|[0mentry[35m|[0m {
 619               [35mconst[0m name [35m=[0m entry.key_ptr[35m.*[0m;
 620               [35mconst[0m module [35m=[0m entry.value_ptr[35m.*[0m;
 621               [35mif[0m (std.mem.eql(u8, name, [32m"build_options"[0m)) [35mcontinue[0m;
 622               [35mif[0m (std.mem.eql(u8, name, [32m"glfw"[0m)) [35mcontinue[0m;
 623   
 624               [35mconst[0m test_exe [35m=[0m b.addTest(.{
 625                   .name [35m=[0m b.fmt([32m"{s}-test"[0m, .{name}),
 626                   .root_source_file [35m=[0m module.source_file,
 627                   .target [35m=[0m target,
 628               });
 629               [35mif[0m (emit_test_exe) b.installArtifact(test_exe);
 630   
 631               [33m_[0m [35m=[0m [35mtry[0m addDeps(b, test_exe, [33mtrue[0m);
 632               [32m// if (pkg.dependencies) |children| {[0m
 633               [32m//     test_.packages = std.ArrayList(std.build.Pkg).init(b.allocator);[0m
 634               [32m//     try test_.packages.appendSlice(children);[0m
 635               [32m// }[0m
 636   
 637               [35mconst[0m test_run [35m=[0m b.addRunArtifact(test_exe);
 638               test_step.dependOn([35m&[0mtest_run.step);
 639           }
 640       }
 641   }
 642   
 643   [32m/// Used to keep track of a list of file sources.[0m
 644   [35mconst[0m FileSourceList [35m=[0m std.ArrayList(std.build.FileSource);
 645   
 646   [32m/// Adds and links all of the primary dependencies for the exe.[0m
 647   [35mfn[0m [34maddDeps[0m(
 648       b: [35m*[0m[35mstd.Build[0m,
 649       step: [35m*[0m[35mstd.build.LibExeObjStep[0m,
 650       static: [35mbool[0m,
 651   ) [35m![0m[35mFileSourceList[0m {
 652       [35mvar[0m static_libs [35m=[0m FileSourceList.init(b.allocator);
 653       [35merrdefer[0m static_libs.deinit();
 654   
 655       [32m// Wasm we do manually since it is such a different build.[0m
 656       [35mif[0m (step.target.getCpuArch() [35m==[0m[33m .wasm32[0m) {
 657           [32m// We link this package but its a no-op since Tracy[0m
 658           [32m// never actually WORKS with wasm.[0m
 659           step.addModule([32m"tracy"[0m, tracylib.module(b));
 660           step.addModule([32m"utf8proc"[0m, utf8proc.module(b));
 661           step.addModule([32m"zig-js"[0m, js.module(b));
 662   
 663           [32m// utf8proc[0m
 664           [33m_[0m [35m=[0m [35mtry[0m utf8proc.link(b, step);
 665   
 666           [35mreturn[0m static_libs;
 667       }
 668   
 669       [32m// For dynamic linking, we prefer dynamic linking and to search by[0m
 670       [32m// mode first. Mode first will search all paths for a dynamic library[0m
 671       [32m// before falling back to static.[0m
 672       [35mconst[0m dynamic_link_opts: [35mstd.build.Step.Compile.LinkSystemLibraryOptions[0m [35m=[0m .{
 673           .preferred_link_mode [35m=[0m[33m .Dynamic[0m,
 674           .search_strategy [35m=[0m[33m .mode_first[0m,
 675       };
 676   
 677       [32m// On Linux, we need to add a couple common library paths that aren't[0m
 678       [32m// on the standard search list. i.e. GTK is often in /usr/lib/x86_64-linux-gnu[0m
 679       [32m// on x86_64.[0m
 680       [35mif[0m (step.target.isLinux()) {
 681           [35mconst[0m triple [35m=[0m [35mtry[0m step.target.linuxTriple(b.allocator);
 682           step.addLibraryPath(.{ .path [35m=[0m b.fmt([32m"/usr/lib/{s}"[0m, .{triple}) });
 683       }
 684   
 685       [32m// C files[0m
 686       step.linkLibC();
 687       step.addIncludePath(.{ .path [35m=[0m [32m"src/stb"[0m });
 688       step.addCSourceFiles(&.{[32m"src/stb/stb.c"[0m}, &.{});
 689   
 690       [32m// If we're building a lib we have some different deps[0m
 691       [35mconst[0m lib [35m=[0m step.kind [35m==[0m[33m .lib[0m;
 692   
 693       [32m// We always require the system SDK so that our system headers are available.[0m
 694       [32m// This makes things like `os/log.h` available for cross-compiling.[0m
 695       system_sdk.include(b, step, .{});
 696   
 697       [32m// We always need the Zig packages[0m
 698       [32m// TODO: This can't be the right way to use the new Zig modules system,[0m
 699       [32m// so take a closer look at this again later.[0m
 700       [35mif[0m (font_backend.hasFontconfig()) step.addModule([32m"fontconfig"[0m, fontconfig.module(b));
 701       [35mconst[0m mod_freetype [35m=[0m freetype.module(b);
 702       [35mconst[0m mod_macos [35m=[0m macos.module(b);
 703       [35mconst[0m mod_libxev [35m=[0m b.createModule(.{
 704           .source_file [35m=[0m .{ .path [35m=[0m [32m"vendor/libxev/src/main.zig"[0m },
 705       });
 706       step.addModule([32m"freetype"[0m, mod_freetype);
 707       step.addModule([32m"harfbuzz"[0m, harfbuzz.module(b, .{
 708           .freetype [35m=[0m mod_freetype,
 709           .macos [35m=[0m mod_macos,
 710       }));
 711       step.addModule([32m"xev"[0m, mod_libxev);
 712       step.addModule([32m"pixman"[0m, pixman.module(b));
 713       step.addModule([32m"utf8proc"[0m, utf8proc.module(b));
 714   
 715       [32m// Mac Stuff[0m
 716       [35mif[0m (step.target.isDarwin()) {
 717           step.addModule([32m"objc"[0m, objc.module(b));
 718           step.addModule([32m"macos"[0m, mod_macos);
 719           [33m_[0m [35m=[0m [35mtry[0m macos.link(b, step, .{});
 720   
 721           [32m// todo: do this is in zig-objc instead.[0m
 722           step.linkSystemLibraryName([32m"objc"[0m);
 723       }
 724   
 725       [32m// Tracy[0m
 726       step.addModule([32m"tracy"[0m, tracylib.module(b));
 727       [35mif[0m (tracy) {
 728           [35mvar[0m tracy_step [35m=[0m [35mtry[0m tracylib.link(b, step);
 729           system_sdk.include(b, tracy_step, .{});
 730       }
 731   
 732       [32m// utf8proc[0m
 733       [35mconst[0m utf8proc_step [35m=[0m [35mtry[0m utf8proc.link(b, step);
 734       [35mtry[0m static_libs.append(utf8proc_step.getEmittedBin());
 735   
 736       [32m// Dynamic link[0m
 737       [35mif[0m ([35m![0mstatic) {
 738           step.addIncludePath(.{ .path [35m=[0m freetype.include_path_self });
 739           step.linkSystemLibrary2([32m"bzip2"[0m, dynamic_link_opts);
 740           step.linkSystemLibrary2([32m"freetype2"[0m, dynamic_link_opts);
 741           step.linkSystemLibrary2([32m"harfbuzz"[0m, dynamic_link_opts);
 742           step.linkSystemLibrary2([32m"libpng"[0m, dynamic_link_opts);
 743           step.linkSystemLibrary2([32m"pixman-1"[0m, dynamic_link_opts);
 744           step.linkSystemLibrary2([32m"zlib"[0m, dynamic_link_opts);
 745   
 746           [35mif[0m (font_backend.hasFontconfig()) {
 747               step.linkSystemLibrary2([32m"fontconfig"[0m, dynamic_link_opts);
 748           }
 749       }
 750   
 751       [32m// Other dependencies, we may dynamically link[0m
 752       [35mif[0m (static) {
 753           [35mconst[0m zlib_step [35m=[0m [35mtry[0m zlib.link(b, step);
 754           [35mtry[0m static_libs.append(zlib_step.getEmittedBin());
 755   
 756           [35mconst[0m libpng_step [35m=[0m [35mtry[0m libpng.link(b, step, .{
 757               .zlib [35m=[0m .{
 758                   .step [35m=[0m zlib_step,
 759                   .include [35m=[0m [35m&[0mzlib.include_paths,
 760               },
 761           });
 762           [35mtry[0m static_libs.append(libpng_step.getEmittedBin());
 763   
 764           [32m// Freetype[0m
 765           [35mconst[0m freetype_step [35m=[0m [35mtry[0m freetype.link(b, step, .{
 766               .libpng [35m=[0m [35mfreetype.Options.Libpng[0m{
 767                   .enabled [35m=[0m [33mtrue[0m,
 768                   .step [35m=[0m libpng_step,
 769                   .include [35m=[0m [35m&[0mlibpng.include_paths,
 770               },
 771   
 772               .zlib [35m=[0m .{
 773                   .enabled [35m=[0m [33mtrue[0m,
 774                   .step [35m=[0m zlib_step,
 775                   .include [35m=[0m [35m&[0mzlib.include_paths,
 776               },
 777           });
 778           [35mtry[0m static_libs.append(freetype_step.getEmittedBin());
 779   
 780           [32m// Harfbuzz[0m
 781           [35mconst[0m harfbuzz_step [35m=[0m [35mtry[0m harfbuzz.link(b, step, .{
 782               .freetype [35m=[0m .{
 783                   .enabled [35m=[0m [33mtrue[0m,
 784                   .step [35m=[0m freetype_step,
 785                   .include [35m=[0m [35m&[0mfreetype.include_paths,
 786               },
 787   
 788               .coretext [35m=[0m .{
 789                   .enabled [35m=[0m font_backend.hasCoretext(),
 790               },
 791           });
 792           system_sdk.include(b, harfbuzz_step, .{});
 793           [35mtry[0m static_libs.append(harfbuzz_step.getEmittedBin());
 794   
 795           [32m// Pixman[0m
 796           [35mconst[0m pixman_step [35m=[0m [35mtry[0m pixman.link(b, step, .{});
 797           [35mtry[0m static_libs.append(pixman_step.getEmittedBin());
 798   
 799           [32m// Only Linux gets fontconfig[0m
 800           [35mif[0m (font_backend.hasFontconfig()) {
 801               [32m// Libxml2[0m
 802               [35mconst[0m libxml2_lib [35m=[0m [35mtry[0m libxml2.create(
 803                   b,
 804                   step.target,
 805                   step.optimize,
 806                   .{
 807                       .lzma [35m=[0m [33mfalse[0m,
 808                       .zlib [35m=[0m [33mfalse[0m,
 809                       .iconv [35m=[0m [35m![0mstep.target.isWindows(),
 810                   },
 811               );
 812               libxml2_lib.link(step);
 813   
 814               [32m// Fontconfig[0m
 815               [35mconst[0m fontconfig_step [35m=[0m [35mtry[0m fontconfig.link(b, step, .{
 816                   .freetype [35m=[0m .{
 817                       .enabled [35m=[0m [33mtrue[0m,
 818                       .step [35m=[0m freetype_step,
 819                       .include [35m=[0m [35m&[0mfreetype.include_paths,
 820                   },
 821   
 822                   .libxml2 [35m=[0m [33mtrue[0m,
 823               });
 824               libxml2_lib.link(fontconfig_step);
 825           }
 826       }
 827   
 828       [35mif[0m ([35m![0mlib) {
 829           [32m// We always statically compile glad[0m
 830           step.addIncludePath(.{ .path [35m=[0m [32m"vendor/glad/include/"[0m });
 831           step.addCSourceFile(.{
 832               .file [35m=[0m .{ .path [35m=[0m [32m"vendor/glad/src/gl.c"[0m },
 833               .flags [35m=[0m &.{},
 834           });
 835   
 836           [32m// When we're targeting flatpak we ALWAYS link GTK so we[0m
 837           [32m// get access to glib for dbus.[0m
 838           [35mif[0m (flatpak) step.linkSystemLibrary2([32m"gtk4"[0m, dynamic_link_opts);
 839   
 840           [35mswitch[0m (app_runtime) {
 841   [33m            .none[0m [35m=[0m[35m>[0m {},
 842   
 843   [33m            .glfw[0m [35m=[0m[35m>[0m {
 844                   step.addModule([32m"glfw"[0m, glfw.module(b));
 845                   [35mconst[0m glfw_opts: [35mglfw.Options[0m [35m=[0m .{
 846                       .metal [35m=[0m step.target.isDarwin(),
 847                       .opengl [35m=[0m [33mfalse[0m,
 848                   };
 849                   [35mtry[0m glfw.link(b, step, glfw_opts);
 850               },
 851   
 852   [33m            .gtk[0m [35m=[0m[35m>[0m {
 853                   [32m// We need glfw for GTK because we use GLFW to get DPI.[0m
 854                   step.addModule([32m"glfw"[0m, glfw.module(b));
 855                   [35mconst[0m glfw_opts: [35mglfw.Options[0m [35m=[0m .{
 856                       .metal [35m=[0m step.target.isDarwin(),
 857                       .opengl [35m=[0m [33mfalse[0m,
 858                   };
 859                   [35mtry[0m glfw.link(b, step, glfw_opts);
 860   
 861                   step.linkSystemLibrary2([32m"gtk4"[0m, dynamic_link_opts);
 862               },
 863           }
 864       }
 865   
 866       [35mreturn[0m static_libs;
 867   }
 868   
 869   [35mfn[0m [34mbenchSteps[0m(
 870       b: [35m*[0m[35mstd.Build[0m,
 871       target: [35mstd.zig.CrossTarget[0m,
 872       optimize: [35mstd.builtin.Mode[0m,
 873       install: [35mbool[0m,
 874   ) [35m![0m[35mvoid[0m {
 875       [32m// Open the directory ./src/bench[0m
 876       [35mconst[0m c_dir_path [35m=[0m ([35mcomptime[0m root()) [35m+[0m[35m+[0m [32m"/src/bench"[0m;
 877       [35mvar[0m c_dir [35m=[0m [35mtry[0m fs.openIterableDirAbsolute(c_dir_path, .{});
 878       [35mdefer[0m c_dir.close();
 879   
 880       [32m// Go through and add each as a step[0m
 881       [35mvar[0m c_dir_it [35m=[0m c_dir.iterate();
 882       [35mwhile[0m ([35mtry[0m c_dir_it.next()) [35m|[0mentry[35m|[0m {
 883           [32m// Get the index of the last '.' so we can strip the extension.[0m
 884           [35mconst[0m index [35m=[0m std.mem.lastIndexOfScalar(u8, entry.name, [32m'.'[0m) [35morelse[0m [35mcontinue[0m;
 885           [35mif[0m (index [35m==[0m [33m0[0m) [35mcontinue[0m;
 886   
 887           [32m// If it doesn't end in 'zig' then ignore[0m
 888           [35mif[0m ([35m![0mstd.mem.eql(u8, entry.name[index [35m+[0m [33m1[0m [35m..[0m], [32m"zig"[0m)) [35mcontinue[0m;
 889   
 890           [32m// Name of the conformance app and full path to the entrypoint.[0m
 891           [35mconst[0m name [35m=[0m entry.name[0[35m..[0mindex];
 892           [35mconst[0m path [35m=[0m [35mtry[0m fs.path.join(b.allocator, &[[33m_[0m][][35mconst[0m [35mu8[0m{
 893               c_dir_path,
 894               entry.name,
 895           });
 896   
 897           [32m// Executable builder.[0m
 898           [35mconst[0m bin_name [35m=[0m [35mtry[0m std.fmt.allocPrint(b.allocator, [32m"bench-{s}"[0m, .{name});
 899           [35mconst[0m c_exe [35m=[0m b.addExecutable(.{
 900               .name [35m=[0m bin_name,
 901               .root_source_file [35m=[0m .{ .path [35m=[0m path },
 902               .target [35m=[0m target,
 903               .optimize [35m=[0m optimize,
 904               .main_pkg_path [35m=[0m .{ .path [35m=[0m [32m"./src"[0m },
 905           });
 906           [35mif[0m (install) b.installArtifact(c_exe);
 907           [33m_[0m [35m=[0m [35mtry[0m addDeps(b, c_exe, [33mtrue[0m);
 908       }
 909   }
 910   
 911   [35mfn[0m [34mconformanceSteps[0m(
 912       b: [35m*[0m[35mstd.Build[0m,
 913       target: [35mstd.zig.CrossTarget[0m,
 914       optimize: [35mstd.builtin.Mode[0m,
 915   ) [35m![0m[35mstd.[0mStringHashMap([35m*[0mLibExeObjStep) {
 916       [35mvar[0m map [35m=[0m std.StringHashMap([35m*[0mLibExeObjStep).init(b.allocator);
 917   
 918       [32m// Open the directory ./conformance[0m
 919       [35mconst[0m c_dir_path [35m=[0m ([35mcomptime[0m root()) [35m+[0m[35m+[0m [32m"/conformance"[0m;
 920       [35mvar[0m c_dir [35m=[0m [35mtry[0m fs.openIterableDirAbsolute(c_dir_path, .{});
 921       [35mdefer[0m c_dir.close();
 922   
 923       [32m// Go through and add each as a step[0m
 924       [35mvar[0m c_dir_it [35m=[0m c_dir.iterate();
 925       [35mwhile[0m ([35mtry[0m c_dir_it.next()) [35m|[0mentry[35m|[0m {
 926           [32m// Get the index of the last '.' so we can strip the extension.[0m
 927           [35mconst[0m index [35m=[0m std.mem.lastIndexOfScalar(u8, entry.name, [32m'.'[0m) [35morelse[0m [35mcontinue[0m;
 928           [35mif[0m (index [35m==[0m [33m0[0m) [35mcontinue[0m;
 929   
 930           [32m// Name of the conformance app and full path to the entrypoint.[0m
 931           [35mconst[0m name [35m=[0m entry.name[0[35m..[0mindex];
 932           [35mconst[0m path [35m=[0m [35mtry[0m fs.path.join(b.allocator, &[[33m_[0m][][35mconst[0m [35mu8[0m{
 933               c_dir_path,
 934               entry.name,
 935           });
 936   
 937           [32m// Executable builder.[0m
 938           [35mconst[0m c_exe [35m=[0m b.addExecutable(.{
 939               .name [35m=[0m name,
 940               .root_source_file [35m=[0m .{ .path [35m=[0m path },
 941               .target [35m=[0m target,
 942               .optimize [35m=[0m optimize,
 943           });
 944   
 945           [35mconst[0m install [35m=[0m b.addInstallArtifact(c_exe, .{});
 946           install.dest_sub_path [35m=[0m [32m"conformance"[0m;
 947           b.getInstallStep().dependOn([35m&[0minstall.step);
 948   
 949           [32m// Store the mapping[0m
 950           [35mtry[0m map.put(name, c_exe);
 951       }
 952   
 953       [35mreturn[0m map;
 954   }
 955   
 956   [32m/// Path to the directory with the build.zig.[0m
 957   [35mfn[0m [34mroot[0m() [][35mconst[0m [35mu8[0m {
 958       [35mreturn[0m std.fs.path.dirname([36m@src[0m().file) [35morelse[0m [35munreachable[0m;
 959   }
 960   
 961   [32m/// ANSI escape codes for colored log output[0m
 962   [35mconst[0m color_map [35m=[0m std.ComptimeStringMap([][35mconst[0m u8, .{
 963       &.{ [32m"black"[0m, [32m"30m"[0m },
 964       &.{ [32m"blue"[0m, [32m"34m"[0m },
 965       &.{ [32m"b"[0m, [32m"1m"[0m },
 966       &.{ [32m"d"[0m, [32m"2m"[0m },
 967       &.{ [32m"cyan"[0m, [32m"36m"[0m },
 968       &.{ [32m"green"[0m, [32m"32m"[0m },
 969       &.{ [32m"magenta"[0m, [32m"35m"[0m },
 970       &.{ [32m"red"[0m, [32m"31m"[0m },
 971       &.{ [32m"white"[0m, [32m"37m"[0m },
 972       &.{ [32m"yellow"[0m, [32m"33m"[0m },
 973   });
