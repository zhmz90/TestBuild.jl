#libhts_detected = false
function detecthts()
    @osx_only info("You should compile libhts.dylab manually and set its location to HTSLIB.libhts")
    false
end
#@osx_only using Homebrew
using BinDeps
@BinDeps.setup
if !detecthts()
    
    # install zlib
    #zlib = library_dependency("zlib", aliases = ["libzlib","zlib1","libzlib.so"])
    #provides(Sources, Dict(URI("http://zlib.net/zlib-1.2.8.tar.gz") => zlib))
    
    # Build libhts

    @osx_only begin
        autoconf = library_dependency("autoconf", aliases=["autoconf"], os=:Darwin)
        #=
        if Pkg.installed("Homebrew") === nothing
            error("Homebrew package not installed, please run Pkg.add(\"Homebrew\")")
        end
        provides( Homebrew.HB, "autoconf", autoconf, os = :Darwin )
        =#
        
        _prefix = joinpath(BinDeps.depsdir(autoconf),"usr")
        _srcdir = joinpath(BinDeps.depsdir(autoconf),"src")
        _autoconfdir = joinpath(_srcdir,"autoconf-2.68")
        #_bindir = joinpath(_prefix, "bin")
        _libdir = joinpath(_prefix, "lib")
        provides(BuildProcess,
                 (@build_steps begin
                  CreateDirectory(_srcdir)
                  CreateDirectory(_libdir)
                  @build_steps begin
                  ChangeDirectory(_srcdir)
                  `rm -rf autoconf`
                  `wget http://ftpmirror.gnu.org/autoconf/autoconf-2.68.tar.gz`
                  `tar xvf autoconf-2.68.tar.gz`
                  FileRule(joinpath(_libdir, "autoconf"), @build_steps begin
                           ChangeDirectory(_autoconfdir)
                           `./configure`
                           `make`
                           `cp bin/autoconf $_libdir`
                           `ls $_libdir`
                           end)
                  end
                 end), autoconf)
        
        
        @BinDeps.install Dict(:autoconf => :autoconf)
    end

    info("Congrats! Successfully build contoconf")
#=
    hts = library_dependency("hts", aliases=["libhts","libhts.so","libhts.dylib","libhts.dll"])#, runtime=true, os=:Unix)
    _prefix = joinpath(BinDeps.depsdir(hts),"usr")
    _srcdir = joinpath(BinDeps.depsdir(hts),"src")
    _htsdir = joinpath(_srcdir,"htslib-1.3")
    _libdir = joinpath(_prefix, "lib")    
    provides(BuildProcess,
             (@build_steps begin
                #CreateDirectory(_srcdir)
                CreateDirectory(_libdir)
                @build_steps begin
                  ChangeDirectory(_srcdir)
                  `rm -rf htslib`
                  `wget https://github.com/samtools/htslib/releases/download/1.3/htslib-1.3.tar.bz2`
                  `tar xvf htslib-1.3.tar.bz2`
                   FileRule(joinpath(_libdir, "libhts.so"), @build_steps begin
                     ChangeDirectory(_htsdir)
                     @linux_only `autoconf`
                     @osx_only `../../bin/autoconf`
                     `./configure`
                     `make`
                     @linux_only `cp libhts.so $_libdir`
                     @osx_only `cp libhts.dylib $_libdir`
                     @windows_only `cp libhts.dll $_libdir`
                   end)
                end
             end), hts)
    
    info("install begins")
    @BinDeps.install Dict(:hts => :hts)
    =#
end
