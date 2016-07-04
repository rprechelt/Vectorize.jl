module VML

const global libvml = Libdl.find_library(["libmkl_vml_avx"], ["/opt/intel/mkl/lib"])
const global librt = Libdl.find_library(["libmkl_rt"], ["/opt/intel/mkl/lib"])
#Libdl.dlopen(libvml)
#Libdl.dlopen(librt)

# ======= VML FUNCTION ACCURACY CONTROL ======= #
const VML_LA               =  0x00000001     # Low Accuracy
const VML_HA               =  0x00000002     # High Accuracy
const VML_EP               =  0x00000003     # Enhanced Performance

# ======= VML ERROR HANDLING CONTROL ======= #
const VML_ERRMODE_IGNORE   =  0x00000100     # ignore errors
const VML_ERRMODE_ERRNO    =  0x00000200     # errno variable is set on error
const VML_ERRMODE_STDERR   =  0x00000400     # error description text is written to stderr
const VML_ERRMODE_EXCEPT   =  0x00000800     # exception is raised on error
const VML_ERRMODE_CALLBACK =  0x00001000     # user's error handler is called
# errno variable is set, exceptions are raised, and user's error handler is called on error
const VML_ERRMODE_DEFAULT  = VML_ERRMODE_ERRNO | VML_ERRMODE_CALLBACK | VML_ERRMODE_EXCEPT

# ======= FTZ & DAZ MODE CONTROL ======= #
const VML_FTZDAZ_ON        =  0x00280000     # faster denormal value processing
const VML_FTZDAZ_OFF       =  0x00140000     # accurate denormal value processing

"""
Sets accuracy, error, and FTZDAZ modes for all VML functions". This is automatically
called in init() but can also be called to change the modes during runtime". 
"""
function setmode(mode)
    ccall(("vmlSetMode", libvml),  Cuint,
          (Cuint,),
          mode)
end

"""
Returns the accuracy, error, and FTZDAZ modes for all VML functions". This is automatically
called in init() but can also be called to change the modes during runtime". 
"""
function setmode(mode)
    status = ccall(("vmlSetMode", libvml),  Cuint,
                   (Cuint,),
                   mode)
    return status
end

end # End Module
