#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <openssl/x509.h>
#include <openssl/x509v3.h>
#include <openssl/x509_vfy.h>
#include <openssl/pem.h>
#include <openssl/err.h>

/*
 * Project structure:
 *
 * MUT-BC-SS-01/
 * ├── certs/
 * ├── src/
 * ├── poc   (binary in root)
 *
 * Execution assumed from PROJECT ROOT
 */
#define CERT_DIR "./certs/"

static void build_path(char *out, size_t size, const char *file) {
    snprintf(out, size, "%s%s", CERT_DIR, file);
}

static X509 *load_cert(const char *path) {
    FILE *f = fopen(path, "r");
    if (!f) {
        fprintf(stderr, "Cannot open: %s\n", path);
        return NULL;
    }

    X509 *c = PEM_read_X509(f, NULL, NULL, NULL);
    fclose(f);

    if (!c) {
        fprintf(stderr, "Failed to parse: %s\n", path);
        ERR_print_errors_fp(stderr);
    }

    return c;
}

static void print_cert_info(const char *label, X509 *c) {
    char subj[256];
    X509_NAME_oneline(X509_get_subject_name(c), subj, sizeof(subj));
    printf("  [%s] subject=%s\n", label, subj);
}

static void run_test(const char *label,
                     const char *root_file,
                     const char *intermediate_file,
                     const char *leaf_file,
                     int strict,
                     int with_purpose) {

    printf("\n--- %s ---\n", label);
    printf("strict=%d  with_purpose=%d\n", strict, with_purpose);

    char root_path[256];
    char interm_path[256];
    char leaf_path[256];

    build_path(root_path, sizeof(root_path), root_file);
    build_path(interm_path, sizeof(interm_path), intermediate_file);
    build_path(leaf_path, sizeof(leaf_path), leaf_file);

    X509 *root         = load_cert(root_path);
    X509 *intermediate = load_cert(interm_path);
    X509 *leaf         = load_cert(leaf_path);

    if (!root || !intermediate || !leaf) {
        printf("RESULT: ERROR loading certs\n");
        if (root) X509_free(root);
        if (intermediate) X509_free(intermediate);
        if (leaf) X509_free(leaf);
        return;
    }

    print_cert_info("ROOT", root);
    print_cert_info("INTERMEDIATE", intermediate);
    print_cert_info("LEAF", leaf);

    /* Trust store */
    X509_STORE *store = X509_STORE_new();
    X509_STORE_add_cert(store, root);

    /* Chain with mutant intermediate */
    STACK_OF(X509) *chain = sk_X509_new_null();
    sk_X509_push(chain, intermediate);

    X509_STORE_CTX *ctx = X509_STORE_CTX_new();
    X509_STORE_CTX_init(ctx, store, leaf, chain);

    if (strict)
        X509_STORE_CTX_set_flags(ctx, X509_V_FLAG_X509_STRICT);

    if (with_purpose) {
        X509_VERIFY_PARAM *param = X509_STORE_CTX_get0_param(ctx);
        X509_VERIFY_PARAM_set_purpose(param, X509_PURPOSE_SSL_SERVER);
    }

    int ret = X509_verify_cert(ctx);
    int err = X509_STORE_CTX_get_error(ctx);

    if (ret == 1) {
        printf("RESULT: ACCEPTED  <<< mutant SURVIVED >>>\n");
    } else {
        printf("RESULT: REJECTED  (err %d: %s)\n",
               err, X509_verify_cert_error_string(err));
    }

    X509_STORE_CTX_free(ctx);
    X509_STORE_free(store);
    sk_X509_free(chain);

    X509_free(root);
    X509_free(intermediate);
    X509_free(leaf);
}

int main(void) {
    printf("=== MUT-BC-SS-01 Mutation Test ===\n");
    printf("OpenSSL: " OPENSSL_VERSION_TEXT "\n");

    run_test("Test 1", "root.pem", "leaf.pem", "subleaf.pem", 0, 0);
    run_test("Test 2", "root.pem", "leaf.pem", "subleaf.pem", 1, 1);
    run_test("Test 3", "root.pem", "leaf.pem", "subleaf.pem", 1, 0);

    return 0;
}
