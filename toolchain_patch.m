#include <stdlib.h>
#include <stdio.h>
#include <objc/objc.h>
#include <objc/objc-runtime.h>

double objc_msgSend_fpret(id self, SEL op, ...) 
{
   Method method = class_getInstanceMethod(self->isa, op);
   int numArgs = method_getNumberOfArguments(method);

   if(numArgs == 2) {
        double (*imp)(id, SEL);
        imp = (double (*)(id, SEL))method->method_imp;
        return imp(self, op);
    } else if(numArgs == 3) {
         va_list ap;
         va_start(ap, op);
         double (*imp)(id, SEL, void *);
         imp = (double (*)(id, SEL, void *))method->method_imp;
         return imp(self, op, va_arg(ap, void *));
    }

    fprintf(stderr, 
       "ERROR: objc_msgSend_fpret called on <%s %p> with selector %s had to return 0.0\n", object_getClassName(self), 
        self, sel_getName(op));
    return 0.0;
}