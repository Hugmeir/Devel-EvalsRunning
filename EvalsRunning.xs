#define PERL_NO_GET_CONTEXT 1
#ifdef WIN32
#  define NO_XSLOCKS
#endif
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

I32
THX_evals_running(pTHX)
{
    dVAR;
    const PERL_CONTEXT *cx;
    I32 cxstack_i = cxstack_ix + 1;
    I32 evals = 0;
    
    while (cxstack_i >= 1 && (cx = &cxstack[cxstack_i])) {
        if (CxTYPE(cx) == CXt_EVAL) {
            /* XXX I don't understand when OPpOFFBYONE would be used;
             * but in any case, we can use it all the time and just
             * check wether we got something senseful
             */
            if ( cxstack_i != (cxstack_ix+1) || cx->blk_eval.retop ) {
                /* Only care about eval {} and eval STRING, not the
                 * pseudo evals set up by require/use
                 */
                if ( CxREALEVAL(cx) || CxTRYBLOCK(cx) ) {
                    evals++;
                }
            }
        }
        cxstack_i--;
    }

    return evals;
}

STATIC int magic_get(pTHX_ SV *sv, MAGIC *mg)
{
    PERL_UNUSED_ARG(mg);
    sv_setiv(sv, THX_evals_running(aTHX));
    return 1;
}

static MGVTBL vtbl = {
  &magic_get, /* get */
  NULL, /* set */
  NULL, /* len */
  NULL, /* clear */
  NULL,
#ifdef MGf_COPY
  NULL, /* copy */
#endif
#ifdef MGf_DUP
# ifdef USE_ITHREADS
  NULL,
# else
  NULL, /* dup */
# endif
#endif
#ifdef MGf_LOCAL
  NULL /* local */
#endif
};

MODULE = Devel::EvalsRunning           PACKAGE = Devel::EvalsRunning          

BOOT:
{
    GV *gv = gv_fetchpvs("\5VALS_RUNNING", GV_ADD|GV_NOTQUAL, SVt_PV);
    SV *sv = GvSVn(gv);
    
    (void)sv_magicext(sv, (SV*)NULL, PERL_MAGIC_ext, &vtbl, (const char *)NULL, 0);
}

I32
evals_running()
PPCODE:
    mPUSHi(THX_evals_running(aTHX));

