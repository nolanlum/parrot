/* api.h
 *  Copyright (C) 2001-2010, Parrot Foundation.
 *  Overview:
 *     Parrot's external embedding API. This functionality is only to be used
 *     by embedding applications, and only this functionality may be used by
 *     them.
 */

#ifndef PARROT_API_H_GUARD
#define PARROT_API_H_GUARD

#include <stdlib.h>
#include <wchar.h>
#include "parrot/compiler.h"
#include "parrot/config.h"
#include "parrot/core_types.h"

typedef int (*imcc_hack_func_t)(Parrot_PMC, const char *, int, const char **, Parrot_PMC*);

#define PARROT_API PARROT_EXPORT

/* having a modified version of PARROT_ASSERT which resolves as an integer
 * rvalue lets us put ASSERT_ARGS() at the top of the list of local variables.
 * Thus, we can catch bad pointers before any of the local initialization
 * logic is run.  And it always returns 0, so headerizer can chain them in
 * ASSERT_ARGS_* macros like:
 * int _ASSERT_ARGS = PARROT_ASSERT_ARG(a) || PARROT_ASSERT_ARG(b) || ...
 */
#ifdef NDEBUG
#  define PARROT_ASSERT(x) /*@-noeffect@*/((void)0)/*@=noeffect@*/
#  define PARROT_ASSERT_ARG(x) (0)
#  define PARROT_FAILURE(x) /*@-noeffect@*/((void)0)/*@=noeffect@*/
#  define PARROT_ASSERT_MSG(x, s) /*@-noeffect@*/((void)0)/*@=noeffect@*/
#  define ASSERT_ARGS(a)
#else
#  define PARROT_ASSERT(x) (x) ? ((void)0) : Parrot_confess(#x, __FILE__, __LINE__)
#  define PARROT_ASSERT_ARG(x) ((x) ? (0) : (Parrot_confess(#x, __FILE__, __LINE__), 0))
#  define PARROT_FAILURE(x) Parrot_confess((x), __FILE__, __LINE__)
#  define PARROT_ASSERT_MSG(x, s) ((x) ? (0) : (Parrot_confess(s, __FILE__, __LINE__), 0))

#  ifdef __GNUC__
#    define ASSERT_ARGS(a) ASSERT_ARGS_ ## a ;
#  else
#    define ASSERT_ARGS(a)
#  endif /* __GNUC__ */

#endif /* NDEBUG */


typedef struct _Parrot_Init_Args {
    void *stacktop;
    const char * gc_system;
    Parrot_Int gc_threshold;
    Parrot_UInt hash_seed;
} Parrot_Init_Args;

#define GET_INIT_STRUCT(i) do {\
        void * __stacktop = NULL; \
        (i) = (Parrot_Init_Args*)calloc(1, sizeof (Parrot_Init_Args)); \
        (i)->stacktop = &__stacktop; \
    } while (0)

/* HEADERIZER BEGIN: src/embed/api.c */
/* Don't modify between HEADERIZER BEGIN / HEADERIZER END.  Your changes will be lost. */

PARROT_API
Parrot_Int Parrot_api_add_dynext_search_path(
    Parrot_PMC interp_pmc,
    ARGIN(const char *path))
        __attribute__nonnull__(2);

PARROT_API
Parrot_Int Parrot_api_add_include_search_path(
    Parrot_PMC interp_pmc,
    ARGIN(const char *path))
        __attribute__nonnull__(2);

PARROT_API
Parrot_Int Parrot_api_add_library_search_path(
    Parrot_PMC interp_pmc,
    ARGIN(const char *path))
        __attribute__nonnull__(2);

PARROT_API
Parrot_Int Parrot_api_build_argv_array(
    Parrot_PMC interp_pmc,
    Parrot_Int argc,
    ARGIN(const char ** argv),
    ARGOUT(Parrot_PMC * args))
        __attribute__nonnull__(3)
        __attribute__nonnull__(4)
        FUNC_MODIFIES(* args);

PARROT_API
Parrot_Int Parrot_api_debug_flag(
    Parrot_PMC interp_pmc,
    Parrot_Int flags,
    Parrot_Int set);

PARROT_API
Parrot_Int Parrot_api_destroy_interpreter(Parrot_PMC interp_pmc);

PARROT_API
Parrot_Int Parrot_api_disassemble_bytecode(
    Parrot_PMC interp_pmc,
    Parrot_PMC pbc,
    ARGIN(const char * const outfile),
    Parrot_Int opts)
        __attribute__nonnull__(3);

PARROT_API
Parrot_Int Parrot_api_flag(
    Parrot_PMC interp_pmc,
    Parrot_Int flags,
    Parrot_Int set);

PARROT_API
Parrot_Int Parrot_api_get_compiler(
    Parrot_PMC interp_pmc,
    Parrot_String type,
    ARGOUT(Parrot_PMC *compiler))
        __attribute__nonnull__(3)
        FUNC_MODIFIES(*compiler);

PARROT_API
Parrot_Int Parrot_api_get_exception_backtrace(
    Parrot_PMC interp_pmc,
    Parrot_PMC exception,
    ARGOUT(Parrot_String * bt))
        __attribute__nonnull__(3)
        FUNC_MODIFIES(* bt);

PARROT_API
Parrot_Int Parrot_api_get_result(
    Parrot_PMC interp_pmc,
    ARGOUT(Parrot_Int *is_error),
    ARGOUT(Parrot_PMC * exception),
    ARGOUT(Parrot_Int *exit_code),
    ARGOUT(Parrot_String * errmsg))
        __attribute__nonnull__(2)
        __attribute__nonnull__(3)
        __attribute__nonnull__(4)
        __attribute__nonnull__(5)
        FUNC_MODIFIES(*is_error)
        FUNC_MODIFIES(* exception)
        FUNC_MODIFIES(*exit_code)
        FUNC_MODIFIES(* errmsg);

PARROT_API
Parrot_Int Parrot_api_get_runtime_path(
    Parrot_PMC interp_pmc,
    ARGOUT(Parrot_String *runtime))
        __attribute__nonnull__(2)
        FUNC_MODIFIES(*runtime);

PARROT_API
Parrot_Int Parrot_api_load_bytecode_bytes(
    Parrot_PMC interp_pmc,
    ARGIN(const unsigned char * const pbc),
    Parrot_Int bytecode_size,
    ARGOUT(Parrot_PMC * pbcpmc))
        __attribute__nonnull__(2)
        __attribute__nonnull__(4)
        FUNC_MODIFIES(* pbcpmc);

PARROT_API
Parrot_Int Parrot_api_load_bytecode_file(
    Parrot_PMC interp_pmc,
    ARGIN(const char *filename),
    ARGOUT(Parrot_PMC * pbc))
        __attribute__nonnull__(2)
        __attribute__nonnull__(3)
        FUNC_MODIFIES(* pbc);

PARROT_API
Parrot_Int Parrot_api_load_language(
    Parrot_PMC interp_pmc,
    Parrot_String lang);

PARROT_API
Parrot_Int Parrot_api_make_interpreter(
    Parrot_PMC parent,
    Parrot_Int flags,
    ARGIN_NULLOK(Parrot_Init_Args *args),
    ARGOUT(Parrot_PMC *interp))
        __attribute__nonnull__(4)
        FUNC_MODIFIES(*interp);

PARROT_API
Parrot_Int Parrot_api_ready_bytecode(
    Parrot_PMC interp_pmc,
    Parrot_PMC pbc,
    ARGOUT(Parrot_PMC *main_sub))
        __attribute__nonnull__(3)
        FUNC_MODIFIES(*main_sub);

PARROT_API
Parrot_Int Parrot_api_run_bytecode(
    Parrot_PMC interp_pmc,
    Parrot_PMC pbc,
    Parrot_PMC mainargs);

PARROT_API
Parrot_Int Parrot_api_set_compiler(
    Parrot_PMC interp_pmc,
    Parrot_String type,
    Parrot_PMC compiler);

PARROT_API
Parrot_Int Parrot_api_set_configuration_hash(
    Parrot_PMC interp_pmc,
    Parrot_PMC confighash);

PARROT_API
Parrot_Int Parrot_api_set_executable_name(
    Parrot_PMC interp_pmc,
    ARGIN(const char * name))
        __attribute__nonnull__(2);

PARROT_API
Parrot_Int Parrot_api_set_output_file(
    Parrot_PMC interp_pmc,
    ARGIN_NULLOK(const char * filename));

PARROT_API
Parrot_Int Parrot_api_set_runcore(
    Parrot_PMC interp_pmc,
    ARGIN(const char * corename),
    Parrot_UInt trace)
        __attribute__nonnull__(2);

PARROT_API
Parrot_Int Parrot_api_set_stdhandles(
    Parrot_PMC interp_pmc,
    Parrot_Int in,
    Parrot_Int out,
    Parrot_Int err);

PARROT_API
Parrot_Int Parrot_api_set_warnings(Parrot_PMC interp_pmc, Parrot_Int flags);

PARROT_API
Parrot_Int Parrot_api_wrap_imcc_hack(
    Parrot_PMC interp_pmc,
    const char * sourcefile,
    int argc,
    const char **argv,
    Parrot_PMC* bytecodepmc,
    int *result,
    imcc_hack_func_t func);

#define ASSERT_ARGS_Parrot_api_add_dynext_search_path \
     __attribute__unused__ int _ASSERT_ARGS_CHECK = (\
       PARROT_ASSERT_ARG(path))
#define ASSERT_ARGS_Parrot_api_add_include_search_path \
     __attribute__unused__ int _ASSERT_ARGS_CHECK = (\
       PARROT_ASSERT_ARG(path))
#define ASSERT_ARGS_Parrot_api_add_library_search_path \
     __attribute__unused__ int _ASSERT_ARGS_CHECK = (\
       PARROT_ASSERT_ARG(path))
#define ASSERT_ARGS_Parrot_api_build_argv_array __attribute__unused__ int _ASSERT_ARGS_CHECK = (\
       PARROT_ASSERT_ARG(argv) \
    , PARROT_ASSERT_ARG(args))
#define ASSERT_ARGS_Parrot_api_debug_flag __attribute__unused__ int _ASSERT_ARGS_CHECK = (0)
#define ASSERT_ARGS_Parrot_api_destroy_interpreter \
     __attribute__unused__ int _ASSERT_ARGS_CHECK = (0)
#define ASSERT_ARGS_Parrot_api_disassemble_bytecode \
     __attribute__unused__ int _ASSERT_ARGS_CHECK = (\
       PARROT_ASSERT_ARG(outfile))
#define ASSERT_ARGS_Parrot_api_flag __attribute__unused__ int _ASSERT_ARGS_CHECK = (0)
#define ASSERT_ARGS_Parrot_api_get_compiler __attribute__unused__ int _ASSERT_ARGS_CHECK = (\
       PARROT_ASSERT_ARG(compiler))
#define ASSERT_ARGS_Parrot_api_get_exception_backtrace \
     __attribute__unused__ int _ASSERT_ARGS_CHECK = (\
       PARROT_ASSERT_ARG(bt))
#define ASSERT_ARGS_Parrot_api_get_result __attribute__unused__ int _ASSERT_ARGS_CHECK = (\
       PARROT_ASSERT_ARG(is_error) \
    , PARROT_ASSERT_ARG(exception) \
    , PARROT_ASSERT_ARG(exit_code) \
    , PARROT_ASSERT_ARG(errmsg))
#define ASSERT_ARGS_Parrot_api_get_runtime_path __attribute__unused__ int _ASSERT_ARGS_CHECK = (\
       PARROT_ASSERT_ARG(runtime))
#define ASSERT_ARGS_Parrot_api_load_bytecode_bytes \
     __attribute__unused__ int _ASSERT_ARGS_CHECK = (\
       PARROT_ASSERT_ARG(pbc) \
    , PARROT_ASSERT_ARG(pbcpmc))
#define ASSERT_ARGS_Parrot_api_load_bytecode_file __attribute__unused__ int _ASSERT_ARGS_CHECK = (\
       PARROT_ASSERT_ARG(filename) \
    , PARROT_ASSERT_ARG(pbc))
#define ASSERT_ARGS_Parrot_api_load_language __attribute__unused__ int _ASSERT_ARGS_CHECK = (0)
#define ASSERT_ARGS_Parrot_api_make_interpreter __attribute__unused__ int _ASSERT_ARGS_CHECK = (\
       PARROT_ASSERT_ARG(interp))
#define ASSERT_ARGS_Parrot_api_ready_bytecode __attribute__unused__ int _ASSERT_ARGS_CHECK = (\
       PARROT_ASSERT_ARG(main_sub))
#define ASSERT_ARGS_Parrot_api_run_bytecode __attribute__unused__ int _ASSERT_ARGS_CHECK = (0)
#define ASSERT_ARGS_Parrot_api_set_compiler __attribute__unused__ int _ASSERT_ARGS_CHECK = (0)
#define ASSERT_ARGS_Parrot_api_set_configuration_hash \
     __attribute__unused__ int _ASSERT_ARGS_CHECK = (0)
#define ASSERT_ARGS_Parrot_api_set_executable_name \
     __attribute__unused__ int _ASSERT_ARGS_CHECK = (\
       PARROT_ASSERT_ARG(name))
#define ASSERT_ARGS_Parrot_api_set_output_file __attribute__unused__ int _ASSERT_ARGS_CHECK = (0)
#define ASSERT_ARGS_Parrot_api_set_runcore __attribute__unused__ int _ASSERT_ARGS_CHECK = (\
       PARROT_ASSERT_ARG(corename))
#define ASSERT_ARGS_Parrot_api_set_stdhandles __attribute__unused__ int _ASSERT_ARGS_CHECK = (0)
#define ASSERT_ARGS_Parrot_api_set_warnings __attribute__unused__ int _ASSERT_ARGS_CHECK = (0)
#define ASSERT_ARGS_Parrot_api_wrap_imcc_hack __attribute__unused__ int _ASSERT_ARGS_CHECK = (0)
/* Don't modify between HEADERIZER BEGIN / HEADERIZER END.  Your changes will be lost. */
/* HEADERIZER END: src/embed/api.c */

/* HEADERIZER BEGIN: src/embed/strings.c */
/* Don't modify between HEADERIZER BEGIN / HEADERIZER END.  Your changes will be lost. */

PARROT_API
Parrot_Int Parrot_api_string_export_ascii(
    Parrot_PMC interp_pmc,
    ARGIN(Parrot_String string),
    ARGOUT(char ** strout))
        __attribute__nonnull__(2)
        __attribute__nonnull__(3)
        FUNC_MODIFIES(* strout);

PARROT_API
Parrot_Int Parrot_api_string_export_wchar(
    Parrot_PMC interp_pmc,
    ARGIN(Parrot_String string),
    ARGOUT(wchar_t ** strout))
        __attribute__nonnull__(2)
        __attribute__nonnull__(3)
        FUNC_MODIFIES(* strout);

PARROT_API
Parrot_Int Parrot_api_string_free_exported_ascii(
    Parrot_PMC interp_pmc,
    ARGIN(char * const str))
        __attribute__nonnull__(2);

PARROT_API
Parrot_Int Parrot_api_string_free_exported_wchar(
    Parrot_PMC interp_pmc,
    ARGIN(wchar_t * const str))
        __attribute__nonnull__(2);

PARROT_API
Parrot_Int Parrot_api_string_import_ascii(
    Parrot_PMC interp_pmc,
    ARGIN(const char * str),
    ARGOUT(Parrot_String * out))
        __attribute__nonnull__(2)
        __attribute__nonnull__(3)
        FUNC_MODIFIES(* out);

PARROT_API
Parrot_Int Parrot_api_string_import_binary(
    Parrot_PMC interp_pmc,
    ARGIN(const unsigned char *bytes),
    Parrot_Int length,
    ARGOUT(Parrot_String *out))
        __attribute__nonnull__(2)
        __attribute__nonnull__(4)
        FUNC_MODIFIES(*out);

PARROT_API
Parrot_Int Parrot_api_string_import_wchar(
    Parrot_PMC interp_pmc,
    ARGIN(wchar_t * str),
    ARGOUT(Parrot_String * out))
        __attribute__nonnull__(2)
        __attribute__nonnull__(3)
        FUNC_MODIFIES(* out);

#define ASSERT_ARGS_Parrot_api_string_export_ascii \
     __attribute__unused__ int _ASSERT_ARGS_CHECK = (\
       PARROT_ASSERT_ARG(string) \
    , PARROT_ASSERT_ARG(strout))
#define ASSERT_ARGS_Parrot_api_string_export_wchar \
     __attribute__unused__ int _ASSERT_ARGS_CHECK = (\
       PARROT_ASSERT_ARG(string) \
    , PARROT_ASSERT_ARG(strout))
#define ASSERT_ARGS_Parrot_api_string_free_exported_ascii \
     __attribute__unused__ int _ASSERT_ARGS_CHECK = (\
       PARROT_ASSERT_ARG(str))
#define ASSERT_ARGS_Parrot_api_string_free_exported_wchar \
     __attribute__unused__ int _ASSERT_ARGS_CHECK = (\
       PARROT_ASSERT_ARG(str))
#define ASSERT_ARGS_Parrot_api_string_import_ascii \
     __attribute__unused__ int _ASSERT_ARGS_CHECK = (\
       PARROT_ASSERT_ARG(str) \
    , PARROT_ASSERT_ARG(out))
#define ASSERT_ARGS_Parrot_api_string_import_binary \
     __attribute__unused__ int _ASSERT_ARGS_CHECK = (\
       PARROT_ASSERT_ARG(bytes) \
    , PARROT_ASSERT_ARG(out))
#define ASSERT_ARGS_Parrot_api_string_import_wchar \
     __attribute__unused__ int _ASSERT_ARGS_CHECK = (\
       PARROT_ASSERT_ARG(str) \
    , PARROT_ASSERT_ARG(out))
/* Don't modify between HEADERIZER BEGIN / HEADERIZER END.  Your changes will be lost. */
/* HEADERIZER END: src/embed/strings.c */

/* HEADERIZER BEGIN: src/embed/pmc.c */
/* Don't modify between HEADERIZER BEGIN / HEADERIZER END.  Your changes will be lost. */

PARROT_API
Parrot_Int Parrot_api_add_exception_handler(
    Parrot_PMC interp_pmc,
    Parrot_PMC handler);

PARROT_API
Parrot_Int Parrot_api_call_sub(
    Parrot_PMC interp_pmc,
    Parrot_PMC sub_pmc,
    ARGIN(const char * signature),
    ...)
        __attribute__nonnull__(3);

PARROT_API
Parrot_Int Parrot_api_pmc_deserialize(
    Parrot_PMC interp_pmc,
    Parrot_String fpmc,
    ARGOUT(Parrot_PMC * pmc))
        __attribute__nonnull__(3)
        FUNC_MODIFIES(* pmc);

PARROT_API
Parrot_Int Parrot_api_pmc_deserialize_bytes(
    Parrot_PMC interp_pmc,
    ARGIN(const unsigned char * const fpmc),
    Parrot_Int length,
    ARGOUT(Parrot_PMC * pmc))
        __attribute__nonnull__(2)
        __attribute__nonnull__(4)
        FUNC_MODIFIES(* pmc);

PARROT_API
Parrot_Int Parrot_api_pmc_get_float(
    Parrot_PMC interp_pmc,
    Parrot_PMC pmc,
    ARGOUT(Parrot_Float * value))
        __attribute__nonnull__(3)
        FUNC_MODIFIES(* value);

PARROT_API
Parrot_Int Parrot_api_pmc_get_integer(
    Parrot_PMC interp_pmc,
    Parrot_PMC pmc,
    ARGOUT(Parrot_Int * value))
        __attribute__nonnull__(3)
        FUNC_MODIFIES(* value);

PARROT_API
Parrot_Int Parrot_api_pmc_get_string(
    Parrot_PMC interp_pmc,
    Parrot_PMC pmc,
    ARGOUT(Parrot_String * str))
        __attribute__nonnull__(3)
        FUNC_MODIFIES(* str);

PARROT_API
Parrot_Int Parrot_api_pmc_null(
    Parrot_PMC interp_pmc,
    ARGMOD(Parrot_PMC *pmctonull))
        __attribute__nonnull__(2)
        FUNC_MODIFIES(*pmctonull);

PARROT_API
Parrot_Int Parrot_api_pmc_set_float(
    Parrot_PMC interp_pmc,
    Parrot_PMC pmc,
    Parrot_Float value);

PARROT_API
Parrot_Int Parrot_api_pmc_set_integer(
    Parrot_PMC interp_pmc,
    Parrot_PMC pmc,
    Parrot_Int value);

PARROT_API
Parrot_Int Parrot_api_pmc_set_string(
    Parrot_PMC interp_pmc,
    Parrot_PMC pmc,
    Parrot_String value);

#define ASSERT_ARGS_Parrot_api_add_exception_handler \
     __attribute__unused__ int _ASSERT_ARGS_CHECK = (0)
#define ASSERT_ARGS_Parrot_api_call_sub __attribute__unused__ int _ASSERT_ARGS_CHECK = (\
       PARROT_ASSERT_ARG(signature))
#define ASSERT_ARGS_Parrot_api_pmc_deserialize __attribute__unused__ int _ASSERT_ARGS_CHECK = (\
       PARROT_ASSERT_ARG(pmc))
#define ASSERT_ARGS_Parrot_api_pmc_deserialize_bytes \
     __attribute__unused__ int _ASSERT_ARGS_CHECK = (\
       PARROT_ASSERT_ARG(fpmc) \
    , PARROT_ASSERT_ARG(pmc))
#define ASSERT_ARGS_Parrot_api_pmc_get_float __attribute__unused__ int _ASSERT_ARGS_CHECK = (\
       PARROT_ASSERT_ARG(value))
#define ASSERT_ARGS_Parrot_api_pmc_get_integer __attribute__unused__ int _ASSERT_ARGS_CHECK = (\
       PARROT_ASSERT_ARG(value))
#define ASSERT_ARGS_Parrot_api_pmc_get_string __attribute__unused__ int _ASSERT_ARGS_CHECK = (\
       PARROT_ASSERT_ARG(str))
#define ASSERT_ARGS_Parrot_api_pmc_null __attribute__unused__ int _ASSERT_ARGS_CHECK = (\
       PARROT_ASSERT_ARG(pmctonull))
#define ASSERT_ARGS_Parrot_api_pmc_set_float __attribute__unused__ int _ASSERT_ARGS_CHECK = (0)
#define ASSERT_ARGS_Parrot_api_pmc_set_integer __attribute__unused__ int _ASSERT_ARGS_CHECK = (0)
#define ASSERT_ARGS_Parrot_api_pmc_set_string __attribute__unused__ int _ASSERT_ARGS_CHECK = (0)
/* Don't modify between HEADERIZER BEGIN / HEADERIZER END.  Your changes will be lost. */
/* HEADERIZER END: src/embed/pmc.c */

/* Forward declaration because IMCC is still part of libparrot, but we don't
   want to include parrot/imcc.h */

PARROT_API
int
imcc_run_api(ARGMOD(Parrot_PMC interp_pmc), ARGIN(const char *sourcefile), int argc,
        ARGIN(const char **argv), ARGOUT(PMC **pbcpmc));

#endif /* PARROT_API_H_GUARD */

/*
 * Local variables:
 *   c-file-style: "parrot"
 * End:
 * vim: expandtab shiftwidth=4 cinoptions='\:2=2' :
 */