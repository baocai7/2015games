.class final Lcom/alipay/sdk/app/j;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Landroid/content/DialogInterface$OnClickListener;


# instance fields
.field final synthetic a:Lcom/alipay/sdk/app/h;


# direct methods
.method constructor <init>(Lcom/alipay/sdk/app/h;)V
    .locals 0

    .prologue
    .line 213
    iput-object p1, p0, Lcom/alipay/sdk/app/j;->a:Lcom/alipay/sdk/app/h;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public final onClick(Landroid/content/DialogInterface;I)V
    .locals 2

    .prologue
    .line 218
    iget-object v0, p0, Lcom/alipay/sdk/app/j;->a:Lcom/alipay/sdk/app/h;

    iget-object v0, v0, Lcom/alipay/sdk/app/h;->a:Landroid/webkit/SslErrorHandler;

    invoke-virtual {v0}, Landroid/webkit/SslErrorHandler;->cancel()V

    .line 219
    iget-object v0, p0, Lcom/alipay/sdk/app/j;->a:Lcom/alipay/sdk/app/h;

    iget-object v0, v0, Lcom/alipay/sdk/app/h;->b:Lcom/alipay/sdk/app/H5PayActivity$a;

    iget-object v0, v0, Lcom/alipay/sdk/app/H5PayActivity$a;->a:Lcom/alipay/sdk/app/H5PayActivity;

    const/4 v1, 0x0

    invoke-static {v0, v1}, Lcom/alipay/sdk/app/H5PayActivity;->a(Lcom/alipay/sdk/app/H5PayActivity;Z)Z

    .line 220
    invoke-static {}, Lcom/alipay/sdk/app/l;->a()Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/alipay/sdk/app/l;->a:Ljava/lang/String;

    .line 221
    iget-object v0, p0, Lcom/alipay/sdk/app/j;->a:Lcom/alipay/sdk/app/h;

    iget-object v0, v0, Lcom/alipay/sdk/app/h;->b:Lcom/alipay/sdk/app/H5PayActivity$a;

    iget-object v0, v0, Lcom/alipay/sdk/app/H5PayActivity$a;->a:Lcom/alipay/sdk/app/H5PayActivity;

    invoke-virtual {v0}, Lcom/alipay/sdk/app/H5PayActivity;->finish()V

    .line 222
    return-void
.end method
