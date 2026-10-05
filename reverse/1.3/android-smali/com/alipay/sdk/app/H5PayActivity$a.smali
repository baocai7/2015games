.class final Lcom/alipay/sdk/app/H5PayActivity$a;
.super Landroid/webkit/WebViewClient;
.source "SourceFile"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/alipay/sdk/app/H5PayActivity;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "a"
.end annotation


# instance fields
.field final synthetic a:Lcom/alipay/sdk/app/H5PayActivity;


# direct methods
.method private constructor <init>(Lcom/alipay/sdk/app/H5PayActivity;)V
    .locals 0

    .prologue
    .line 178
    iput-object p1, p0, Lcom/alipay/sdk/app/H5PayActivity$a;->a:Lcom/alipay/sdk/app/H5PayActivity;

    invoke-direct {p0}, Landroid/webkit/WebViewClient;-><init>()V

    return-void
.end method

.method synthetic constructor <init>(Lcom/alipay/sdk/app/H5PayActivity;B)V
    .locals 0

    .prologue
    .line 178
    invoke-direct {p0, p1}, Lcom/alipay/sdk/app/H5PayActivity$a;-><init>(Lcom/alipay/sdk/app/H5PayActivity;)V

    return-void
.end method


# virtual methods
.method public final onLoadResource(Landroid/webkit/WebView;Ljava/lang/String;)V
    .locals 0

    .prologue
    .line 318
    return-void
.end method

.method public final onPageFinished(Landroid/webkit/WebView;Ljava/lang/String;)V
    .locals 2

    .prologue
    .line 329
    iget-object v0, p0, Lcom/alipay/sdk/app/H5PayActivity$a;->a:Lcom/alipay/sdk/app/H5PayActivity;

    invoke-static {v0}, Lcom/alipay/sdk/app/H5PayActivity;->f(Lcom/alipay/sdk/app/H5PayActivity;)V

    .line 330
    iget-object v0, p0, Lcom/alipay/sdk/app/H5PayActivity$a;->a:Lcom/alipay/sdk/app/H5PayActivity;

    invoke-static {v0}, Lcom/alipay/sdk/app/H5PayActivity;->e(Lcom/alipay/sdk/app/H5PayActivity;)Landroid/os/Handler;

    move-result-object v0

    iget-object v1, p0, Lcom/alipay/sdk/app/H5PayActivity$a;->a:Lcom/alipay/sdk/app/H5PayActivity;

    invoke-static {v1}, Lcom/alipay/sdk/app/H5PayActivity;->d(Lcom/alipay/sdk/app/H5PayActivity;)Ljava/lang/Runnable;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 331
    return-void
.end method

.method public final onPageStarted(Landroid/webkit/WebView;Ljava/lang/String;Landroid/graphics/Bitmap;)V
    .locals 4

    .prologue
    .line 322
    iget-object v0, p0, Lcom/alipay/sdk/app/H5PayActivity$a;->a:Lcom/alipay/sdk/app/H5PayActivity;

    invoke-static {v0}, Lcom/alipay/sdk/app/H5PayActivity;->c(Lcom/alipay/sdk/app/H5PayActivity;)V

    .line 323
    iget-object v0, p0, Lcom/alipay/sdk/app/H5PayActivity$a;->a:Lcom/alipay/sdk/app/H5PayActivity;

    invoke-static {v0}, Lcom/alipay/sdk/app/H5PayActivity;->e(Lcom/alipay/sdk/app/H5PayActivity;)Landroid/os/Handler;

    move-result-object v0

    iget-object v1, p0, Lcom/alipay/sdk/app/H5PayActivity$a;->a:Lcom/alipay/sdk/app/H5PayActivity;

    invoke-static {v1}, Lcom/alipay/sdk/app/H5PayActivity;->d(Lcom/alipay/sdk/app/H5PayActivity;)Ljava/lang/Runnable;

    move-result-object v1

    const-wide/16 v2, 0x7530

    invoke-virtual {v0, v1, v2, v3}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 324
    invoke-super {p0, p1, p2, p3}, Landroid/webkit/WebViewClient;->onPageStarted(Landroid/webkit/WebView;Ljava/lang/String;Landroid/graphics/Bitmap;)V

    .line 325
    return-void
.end method

.method public final onReceivedError(Landroid/webkit/WebView;ILjava/lang/String;Ljava/lang/String;)V
    .locals 1

    .prologue
    .line 183
    iget-object v0, p0, Lcom/alipay/sdk/app/H5PayActivity$a;->a:Lcom/alipay/sdk/app/H5PayActivity;

    invoke-static {v0}, Lcom/alipay/sdk/app/H5PayActivity;->a(Lcom/alipay/sdk/app/H5PayActivity;)Z

    .line 184
    invoke-super {p0, p1, p2, p3, p4}, Landroid/webkit/WebViewClient;->onReceivedError(Landroid/webkit/WebView;ILjava/lang/String;Ljava/lang/String;)V

    .line 185
    return-void
.end method

.method public final onReceivedSslError(Landroid/webkit/WebView;Landroid/webkit/SslErrorHandler;Landroid/net/http/SslError;)V
    .locals 2

    .prologue
    .line 193
    iget-object v0, p0, Lcom/alipay/sdk/app/H5PayActivity$a;->a:Lcom/alipay/sdk/app/H5PayActivity;

    invoke-static {v0}, Lcom/alipay/sdk/app/H5PayActivity;->b(Lcom/alipay/sdk/app/H5PayActivity;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 194
    invoke-virtual {p2}, Landroid/webkit/SslErrorHandler;->proceed()V

    .line 195
    iget-object v0, p0, Lcom/alipay/sdk/app/H5PayActivity$a;->a:Lcom/alipay/sdk/app/H5PayActivity;

    const/4 v1, 0x0

    invoke-static {v0, v1}, Lcom/alipay/sdk/app/H5PayActivity;->a(Lcom/alipay/sdk/app/H5PayActivity;Z)Z

    .line 227
    :goto_0
    return-void

    .line 199
    :cond_0
    iget-object v0, p0, Lcom/alipay/sdk/app/H5PayActivity$a;->a:Lcom/alipay/sdk/app/H5PayActivity;

    new-instance v1, Lcom/alipay/sdk/app/h;

    invoke-direct {v1, p0, p2}, Lcom/alipay/sdk/app/h;-><init>(Lcom/alipay/sdk/app/H5PayActivity$a;Landroid/webkit/SslErrorHandler;)V

    invoke-virtual {v0, v1}, Lcom/alipay/sdk/app/H5PayActivity;->runOnUiThread(Ljava/lang/Runnable;)V

    goto :goto_0
.end method

.method public final shouldOverrideUrlLoading(Landroid/webkit/WebView;Ljava/lang/String;)Z
    .locals 7

    .prologue
    const/4 v0, 0x0

    const/4 v1, 0x1

    .line 232
    const-string v2, "alipays://platformapi/startApp?"

    invoke-virtual {p2, v2}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_0

    .line 314
    :goto_0
    return v0

    .line 235
    :cond_0
    const-string v0, "sdklite://h5quit"

    invoke-static {p2, v0}, Landroid/text/TextUtils;->equals(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Z

    move-result v0

    if-nez v0, :cond_1

    const-string v0, "http://m.alipay.com/?action=h5quit"

    invoke-static {p2, v0}, Landroid/text/TextUtils;->equals(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_2

    .line 237
    :cond_1
    invoke-static {}, Lcom/alipay/sdk/app/l;->a()Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/alipay/sdk/app/l;->a:Ljava/lang/String;

    .line 238
    iget-object v0, p0, Lcom/alipay/sdk/app/H5PayActivity$a;->a:Lcom/alipay/sdk/app/H5PayActivity;

    invoke-virtual {v0}, Lcom/alipay/sdk/app/H5PayActivity;->finish()V

    move v0, v1

    .line 239
    goto :goto_0

    .line 242
    :cond_2
    const-string v0, "sdklite://h5quit?result="

    invoke-virtual {p2, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_6

    .line 244
    :try_start_0
    const-string v0, "sdklite://h5quit?result="

    invoke-virtual {p2, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v0

    add-int/lit8 v0, v0, 0x18

    invoke-virtual {p2, v0}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v0

    .line 247
    const-string v2, "&end_code="

    invoke-virtual {v0, v2}, Ljava/lang/String;->lastIndexOf(Ljava/lang/String;)I

    move-result v2

    add-int/lit8 v2, v2, 0xa

    invoke-virtual {v0, v2}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v0

    .line 250
    invoke-static {v0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v2

    .line 251
    sget-object v0, Lcom/alipay/sdk/app/m;->a:Lcom/alipay/sdk/app/m;

    iget v0, v0, Lcom/alipay/sdk/app/m;->g:I

    if-eq v2, v0, :cond_3

    sget-object v0, Lcom/alipay/sdk/app/m;->f:Lcom/alipay/sdk/app/m;

    iget v0, v0, Lcom/alipay/sdk/app/m;->g:I

    if-ne v2, v0, :cond_5

    .line 253
    :cond_3
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    .line 254
    invoke-static {p2}, Ljava/net/URLDecoder;->decode(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 256
    const-string v4, "sdklite://h5quit?result="

    invoke-virtual {v0, v4}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v4

    add-int/lit8 v4, v4, 0x18

    const-string v5, "&end_code="

    invoke-virtual {v0, v5}, Ljava/lang/String;->lastIndexOf(Ljava/lang/String;)I

    move-result v5

    invoke-virtual {v0, v4, v5}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v0

    .line 265
    const-string v4, "&return_url=\""

    invoke-virtual {v0, v4}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v4

    if-eqz v4, :cond_4

    .line 266
    const-string v4, "&return_url=\""

    invoke-virtual {v0, v4}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v4

    .line 268
    const/4 v5, 0x0

    aget-object v4, v4, v5

    .line 270
    const-string v5, "&return_url=\""

    invoke-virtual {v0, v5}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v5

    .line 272
    add-int/lit8 v5, v5, 0xd

    .line 275
    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v6, "&return_url=\""

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v6, "\"&"

    invoke-virtual {v0, v6, v5}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v6

    invoke-virtual {v0, v5, v6}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v6, "\"&"

    invoke-virtual {v0, v6, v5}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v5

    invoke-virtual {v0, v5}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 283
    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 286
    :cond_4
    invoke-static {v2}, Lcom/alipay/sdk/app/m;->a(I)Lcom/alipay/sdk/app/m;

    move-result-object v2

    .line 288
    iget v3, v2, Lcom/alipay/sdk/app/m;->g:I

    iget-object v2, v2, Lcom/alipay/sdk/app/m;->h:Ljava/lang/String;

    invoke-static {v3, v2, v0}, Lcom/alipay/sdk/app/l;->a(ILjava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/alipay/sdk/app/l;->a:Ljava/lang/String;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 302
    :goto_1
    new-instance v0, Lcom/alipay/sdk/app/k;

    invoke-direct {v0, p0}, Lcom/alipay/sdk/app/k;-><init>(Lcom/alipay/sdk/app/H5PayActivity$a;)V

    .line 308
    iget-object v2, p0, Lcom/alipay/sdk/app/H5PayActivity$a;->a:Lcom/alipay/sdk/app/H5PayActivity;

    invoke-virtual {v2, v0}, Lcom/alipay/sdk/app/H5PayActivity;->runOnUiThread(Ljava/lang/Runnable;)V

    move v0, v1

    .line 310
    goto/16 :goto_0

    .line 293
    :cond_5
    :try_start_1
    sget-object v0, Lcom/alipay/sdk/app/m;->b:Lcom/alipay/sdk/app/m;

    iget v0, v0, Lcom/alipay/sdk/app/m;->g:I

    invoke-static {v0}, Lcom/alipay/sdk/app/m;->a(I)Lcom/alipay/sdk/app/m;

    move-result-object v0

    .line 295
    iget v2, v0, Lcom/alipay/sdk/app/m;->g:I

    iget-object v0, v0, Lcom/alipay/sdk/app/m;->h:Ljava/lang/String;

    const-string v3, ""

    invoke-static {v2, v0, v3}, Lcom/alipay/sdk/app/l;->a(ILjava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/alipay/sdk/app/l;->a:Ljava/lang/String;
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    goto :goto_1

    .line 300
    :catch_0
    move-exception v0

    invoke-static {}, Lcom/alipay/sdk/app/l;->b()Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/alipay/sdk/app/l;->a:Ljava/lang/String;

    goto :goto_1

    .line 313
    :cond_6
    invoke-virtual {p1, p2}, Landroid/webkit/WebView;->loadUrl(Ljava/lang/String;)V

    move v0, v1

    .line 314
    goto/16 :goto_0
.end method
