.class final Lcom/alipay/sdk/auth/o;
.super Ljava/lang/Object;

# interfaces
.implements Landroid/content/DialogInterface$OnClickListener;


# instance fields
.field final synthetic a:Lcom/alipay/sdk/auth/m;


# direct methods
.method constructor <init>(Lcom/alipay/sdk/auth/m;)V
    .locals 0

    iput-object p1, p0, Lcom/alipay/sdk/auth/o;->a:Lcom/alipay/sdk/auth/m;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public final onClick(Landroid/content/DialogInterface;I)V
    .locals 2

    iget-object v0, p0, Lcom/alipay/sdk/auth/o;->a:Lcom/alipay/sdk/auth/m;

    iget-object v0, v0, Lcom/alipay/sdk/auth/m;->a:Landroid/webkit/SslErrorHandler;

    invoke-virtual {v0}, Landroid/webkit/SslErrorHandler;->cancel()V

    iget-object v0, p0, Lcom/alipay/sdk/auth/o;->a:Lcom/alipay/sdk/auth/m;

    iget-object v0, v0, Lcom/alipay/sdk/auth/m;->b:Lcom/alipay/sdk/auth/AuthActivity$b;

    iget-object v0, v0, Lcom/alipay/sdk/auth/AuthActivity$b;->a:Lcom/alipay/sdk/auth/AuthActivity;

    const/4 v1, 0x0

    invoke-static {v0, v1}, Lcom/alipay/sdk/auth/AuthActivity;->a(Lcom/alipay/sdk/auth/AuthActivity;Z)Z

    invoke-static {}, Lcom/alipay/sdk/app/ab;->a()Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/alipay/sdk/app/ab;->a:Ljava/lang/String;

    iget-object v0, p0, Lcom/alipay/sdk/auth/o;->a:Lcom/alipay/sdk/auth/m;

    iget-object v0, v0, Lcom/alipay/sdk/auth/m;->b:Lcom/alipay/sdk/auth/AuthActivity$b;

    iget-object v0, v0, Lcom/alipay/sdk/auth/AuthActivity$b;->a:Lcom/alipay/sdk/auth/AuthActivity;

    invoke-virtual {v0}, Lcom/alipay/sdk/auth/AuthActivity;->finish()V

    return-void
.end method
