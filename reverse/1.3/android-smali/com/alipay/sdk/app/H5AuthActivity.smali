.class public Lcom/alipay/sdk/app/H5AuthActivity;
.super Landroid/app/Activity;
.source "SourceFile"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/alipay/sdk/app/H5AuthActivity$a;
    }
.end annotation


# instance fields
.field private a:Landroid/webkit/WebView;

.field private b:Lcom/alipay/sdk/widget/a;

.field private c:Landroid/os/Handler;

.field private d:Z

.field private e:Z

.field private f:Ljava/lang/Runnable;


# direct methods
.method public constructor <init>()V
    .locals 1

    .prologue
    .line 42
    invoke-direct {p0}, Landroid/app/Activity;-><init>()V

    .line 302
    new-instance v0, Lcom/alipay/sdk/app/b;

    invoke-direct {v0, p0}, Lcom/alipay/sdk/app/b;-><init>(Lcom/alipay/sdk/app/H5AuthActivity;)V

    iput-object v0, p0, Lcom/alipay/sdk/app/H5AuthActivity;->f:Ljava/lang/Runnable;

    return-void
.end method

.method private static a()V
    .locals 2

    .prologue
    .line 165
    sget-object v1, Lcom/alipay/sdk/app/AuthTask;->a:Ljava/lang/Object;

    .line 167
    monitor-enter v1

    .line 169
    :try_start_0
    invoke-virtual {v1}, Ljava/lang/Object;->notify()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 172
    :goto_0
    :try_start_1
    monitor-exit v1
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    return-void

    :catchall_0
    move-exception v0

    monitor-exit v1

    throw v0

    :catch_0
    move-exception v0

    goto :goto_0
.end method

.method static synthetic a(Lcom/alipay/sdk/app/H5AuthActivity;)Z
    .locals 1

    .prologue
    .line 42
    const/4 v0, 0x1

    iput-boolean v0, p0, Lcom/alipay/sdk/app/H5AuthActivity;->e:Z

    return v0
.end method

.method static synthetic a(Lcom/alipay/sdk/app/H5AuthActivity;Z)Z
    .locals 0

    .prologue
    .line 42
    iput-boolean p1, p0, Lcom/alipay/sdk/app/H5AuthActivity;->d:Z

    return p1
.end method

.method private b()V
    .locals 1

    .prologue
    .line 311
    iget-object v0, p0, Lcom/alipay/sdk/app/H5AuthActivity;->b:Lcom/alipay/sdk/widget/a;

    if-nez v0, :cond_0

    .line 312
    new-instance v0, Lcom/alipay/sdk/widget/a;

    invoke-direct {v0, p0}, Lcom/alipay/sdk/widget/a;-><init>(Landroid/app/Activity;)V

    iput-object v0, p0, Lcom/alipay/sdk/app/H5AuthActivity;->b:Lcom/alipay/sdk/widget/a;

    .line 314
    :cond_0
    :try_start_0
    iget-object v0, p0, Lcom/alipay/sdk/app/H5AuthActivity;->b:Lcom/alipay/sdk/widget/a;

    invoke-virtual {v0}, Lcom/alipay/sdk/widget/a;->b()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 318
    :goto_0
    return-void

    .line 316
    :catch_0
    move-exception v0

    const/4 v0, 0x0

    iput-object v0, p0, Lcom/alipay/sdk/app/H5AuthActivity;->b:Lcom/alipay/sdk/widget/a;

    goto :goto_0
.end method

.method static synthetic b(Lcom/alipay/sdk/app/H5AuthActivity;)Z
    .locals 1

    .prologue
    .line 42
    iget-boolean v0, p0, Lcom/alipay/sdk/app/H5AuthActivity;->d:Z

    return v0
.end method

.method private c()V
    .locals 1

    .prologue
    .line 321
    iget-object v0, p0, Lcom/alipay/sdk/app/H5AuthActivity;->b:Lcom/alipay/sdk/widget/a;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/alipay/sdk/app/H5AuthActivity;->b:Lcom/alipay/sdk/widget/a;

    invoke-virtual {v0}, Lcom/alipay/sdk/widget/a;->a()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 322
    iget-object v0, p0, Lcom/alipay/sdk/app/H5AuthActivity;->b:Lcom/alipay/sdk/widget/a;

    invoke-virtual {v0}, Lcom/alipay/sdk/widget/a;->c()V

    .line 323
    :cond_0
    const/4 v0, 0x0

    iput-object v0, p0, Lcom/alipay/sdk/app/H5AuthActivity;->b:Lcom/alipay/sdk/widget/a;

    .line 324
    return-void
.end method

.method static synthetic c(Lcom/alipay/sdk/app/H5AuthActivity;)V
    .locals 1

    .prologue
    .line 42
    iget-object v0, p0, Lcom/alipay/sdk/app/H5AuthActivity;->b:Lcom/alipay/sdk/widget/a;

    if-nez v0, :cond_0

    new-instance v0, Lcom/alipay/sdk/widget/a;

    invoke-direct {v0, p0}, Lcom/alipay/sdk/widget/a;-><init>(Landroid/app/Activity;)V

    iput-object v0, p0, Lcom/alipay/sdk/app/H5AuthActivity;->b:Lcom/alipay/sdk/widget/a;

    :cond_0
    :try_start_0
    iget-object v0, p0, Lcom/alipay/sdk/app/H5AuthActivity;->b:Lcom/alipay/sdk/widget/a;

    invoke-virtual {v0}, Lcom/alipay/sdk/widget/a;->b()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :goto_0
    return-void

    :catch_0
    move-exception v0

    const/4 v0, 0x0

    iput-object v0, p0, Lcom/alipay/sdk/app/H5AuthActivity;->b:Lcom/alipay/sdk/widget/a;

    goto :goto_0
.end method

.method static synthetic d(Lcom/alipay/sdk/app/H5AuthActivity;)Ljava/lang/Runnable;
    .locals 1

    .prologue
    .line 42
    iget-object v0, p0, Lcom/alipay/sdk/app/H5AuthActivity;->f:Ljava/lang/Runnable;

    return-object v0
.end method

.method static synthetic e(Lcom/alipay/sdk/app/H5AuthActivity;)Landroid/os/Handler;
    .locals 1

    .prologue
    .line 42
    iget-object v0, p0, Lcom/alipay/sdk/app/H5AuthActivity;->c:Landroid/os/Handler;

    return-object v0
.end method

.method static synthetic f(Lcom/alipay/sdk/app/H5AuthActivity;)V
    .locals 1

    .prologue
    .line 42
    iget-object v0, p0, Lcom/alipay/sdk/app/H5AuthActivity;->b:Lcom/alipay/sdk/widget/a;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/alipay/sdk/app/H5AuthActivity;->b:Lcom/alipay/sdk/widget/a;

    invoke-virtual {v0}, Lcom/alipay/sdk/widget/a;->a()Z

    move-result v0

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/alipay/sdk/app/H5AuthActivity;->b:Lcom/alipay/sdk/widget/a;

    invoke-virtual {v0}, Lcom/alipay/sdk/widget/a;->c()V

    :cond_0
    const/4 v0, 0x0

    iput-object v0, p0, Lcom/alipay/sdk/app/H5AuthActivity;->b:Lcom/alipay/sdk/widget/a;

    return-void
.end method


# virtual methods
.method public finish()V
    .locals 2

    .prologue
    .line 160
    sget-object v1, Lcom/alipay/sdk/app/AuthTask;->a:Ljava/lang/Object;

    monitor-enter v1

    :try_start_0
    invoke-virtual {v1}, Ljava/lang/Object;->notify()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    :goto_0
    :try_start_1
    monitor-exit v1
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 161
    invoke-super {p0}, Landroid/app/Activity;->finish()V

    .line 162
    return-void

    .line 160
    :catchall_0
    move-exception v0

    monitor-exit v1

    throw v0

    :catch_0
    move-exception v0

    goto :goto_0
.end method

.method public onBackPressed()V
    .locals 3

    .prologue
    .line 143
    iget-object v0, p0, Lcom/alipay/sdk/app/H5AuthActivity;->a:Landroid/webkit/WebView;

    invoke-virtual {v0}, Landroid/webkit/WebView;->canGoBack()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 144
    iget-boolean v0, p0, Lcom/alipay/sdk/app/H5AuthActivity;->e:Z

    if-eqz v0, :cond_0

    .line 145
    sget-object v0, Lcom/alipay/sdk/app/m;->d:Lcom/alipay/sdk/app/m;

    iget v0, v0, Lcom/alipay/sdk/app/m;->g:I

    invoke-static {v0}, Lcom/alipay/sdk/app/m;->a(I)Lcom/alipay/sdk/app/m;

    move-result-object v0

    .line 147
    iget v1, v0, Lcom/alipay/sdk/app/m;->g:I

    iget-object v0, v0, Lcom/alipay/sdk/app/m;->h:Ljava/lang/String;

    const-string v2, ""

    invoke-static {v1, v0, v2}, Lcom/alipay/sdk/app/l;->a(ILjava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/alipay/sdk/app/l;->a:Ljava/lang/String;

    .line 149
    invoke-virtual {p0}, Lcom/alipay/sdk/app/H5AuthActivity;->finish()V

    .line 156
    :cond_0
    :goto_0
    return-void

    .line 154
    :cond_1
    invoke-static {}, Lcom/alipay/sdk/app/l;->a()Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/alipay/sdk/app/l;->a:Ljava/lang/String;

    .line 155
    invoke-virtual {p0}, Lcom/alipay/sdk/app/H5AuthActivity;->finish()V

    goto :goto_0
.end method

.method public onConfigurationChanged(Landroid/content/res/Configuration;)V
    .locals 0

    .prologue
    .line 328
    invoke-super {p0, p1}, Landroid/app/Activity;->onConfigurationChanged(Landroid/content/res/Configuration;)V

    .line 329
    return-void
.end method

.method protected onCreate(Landroid/os/Bundle;)V
    .locals 7

    .prologue
    const/4 v3, -0x1

    const/4 v6, 0x0

    const/4 v5, 0x1

    .line 52
    invoke-super {p0, p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V

    .line 53
    :try_start_0
    invoke-virtual {p0}, Lcom/alipay/sdk/app/H5AuthActivity;->getIntent()Landroid/content/Intent;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/Intent;->getExtras()Landroid/os/Bundle;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    move-result-object v0

    .line 60
    if-nez v0, :cond_1

    .line 61
    invoke-virtual {p0}, Lcom/alipay/sdk/app/H5AuthActivity;->finish()V

    .line 139
    :cond_0
    :goto_0
    return-void

    .line 57
    :catch_0
    move-exception v0

    invoke-virtual {p0}, Lcom/alipay/sdk/app/H5AuthActivity;->finish()V

    goto :goto_0

    .line 64
    :cond_1
    :try_start_1
    const-string v1, "url"

    invoke-virtual {v0, v1}, Landroid/os/Bundle;->getString(Ljava/lang/String;)Ljava/lang/String;
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1

    move-result-object v0

    .line 71
    invoke-static {v0}, Lcom/alipay/sdk/util/k;->a(Ljava/lang/String;)Z

    move-result v1

    .line 72
    if-nez v1, :cond_2

    .line 73
    invoke-virtual {p0}, Lcom/alipay/sdk/app/H5AuthActivity;->finish()V

    goto :goto_0

    .line 68
    :catch_1
    move-exception v0

    invoke-virtual {p0}, Lcom/alipay/sdk/app/H5AuthActivity;->finish()V

    goto :goto_0

    .line 77
    :cond_2
    invoke-super {p0, v5}, Landroid/app/Activity;->requestWindowFeature(I)Z

    .line 78
    new-instance v1, Landroid/os/Handler;

    invoke-virtual {p0}, Lcom/alipay/sdk/app/H5AuthActivity;->getMainLooper()Landroid/os/Looper;

    move-result-object v2

    invoke-direct {v1, v2}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    iput-object v1, p0, Lcom/alipay/sdk/app/H5AuthActivity;->c:Landroid/os/Handler;

    .line 80
    new-instance v1, Landroid/widget/LinearLayout;

    invoke-virtual {p0}, Lcom/alipay/sdk/app/H5AuthActivity;->getApplicationContext()Landroid/content/Context;

    move-result-object v2

    invoke-direct {v1, v2}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    .line 81
    new-instance v2, Landroid/widget/LinearLayout$LayoutParams;

    invoke-direct {v2, v3, v3}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    .line 83
    invoke-virtual {v1, v5}, Landroid/widget/LinearLayout;->setOrientation(I)V

    .line 84
    invoke-virtual {p0, v1, v2}, Lcom/alipay/sdk/app/H5AuthActivity;->setContentView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 86
    new-instance v3, Landroid/webkit/WebView;

    invoke-virtual {p0}, Lcom/alipay/sdk/app/H5AuthActivity;->getApplicationContext()Landroid/content/Context;

    move-result-object v4

    invoke-direct {v3, v4}, Landroid/webkit/WebView;-><init>(Landroid/content/Context;)V

    iput-object v3, p0, Lcom/alipay/sdk/app/H5AuthActivity;->a:Landroid/webkit/WebView;

    .line 87
    const/high16 v3, 0x3f800000    # 1.0f

    iput v3, v2, Landroid/widget/LinearLayout$LayoutParams;->weight:F

    .line 88
    iget-object v3, p0, Lcom/alipay/sdk/app/H5AuthActivity;->a:Landroid/webkit/WebView;

    invoke-virtual {v3, v6}, Landroid/webkit/WebView;->setVisibility(I)V

    .line 89
    iget-object v3, p0, Lcom/alipay/sdk/app/H5AuthActivity;->a:Landroid/webkit/WebView;

    invoke-virtual {v1, v3, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 91
    iget-object v1, p0, Lcom/alipay/sdk/app/H5AuthActivity;->a:Landroid/webkit/WebView;

    invoke-virtual {v1}, Landroid/webkit/WebView;->getSettings()Landroid/webkit/WebSettings;

    move-result-object v1

    .line 92
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1}, Landroid/webkit/WebSettings;->getUserAgentString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {p0}, Lcom/alipay/sdk/app/H5AuthActivity;->getApplicationContext()Landroid/content/Context;

    move-result-object v3

    invoke-static {v3}, Lcom/alipay/sdk/util/k;->c(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Landroid/webkit/WebSettings;->setUserAgentString(Ljava/lang/String;)V

    .line 94
    sget-object v2, Landroid/webkit/WebSettings$RenderPriority;->HIGH:Landroid/webkit/WebSettings$RenderPriority;

    invoke-virtual {v1, v2}, Landroid/webkit/WebSettings;->setRenderPriority(Landroid/webkit/WebSettings$RenderPriority;)V

    .line 95
    invoke-virtual {v1, v5}, Landroid/webkit/WebSettings;->setSupportMultipleWindows(Z)V

    .line 96
    invoke-virtual {v1, v5}, Landroid/webkit/WebSettings;->setJavaScriptEnabled(Z)V

    .line 97
    invoke-virtual {v1, v6}, Landroid/webkit/WebSettings;->setSavePassword(Z)V

    .line 98
    invoke-virtual {v1, v5}, Landroid/webkit/WebSettings;->setJavaScriptCanOpenWindowsAutomatically(Z)V

    .line 99
    invoke-virtual {v1}, Landroid/webkit/WebSettings;->getMinimumFontSize()I

    move-result v2

    add-int/lit8 v2, v2, 0x8

    invoke-virtual {v1, v2}, Landroid/webkit/WebSettings;->setMinimumFontSize(I)V

    .line 100
    invoke-virtual {v1, v6}, Landroid/webkit/WebSettings;->setAllowFileAccess(Z)V

    .line 101
    sget-object v2, Landroid/webkit/WebSettings$TextSize;->NORMAL:Landroid/webkit/WebSettings$TextSize;

    invoke-virtual {v1, v2}, Landroid/webkit/WebSettings;->setTextSize(Landroid/webkit/WebSettings$TextSize;)V

    .line 102
    iget-object v1, p0, Lcom/alipay/sdk/app/H5AuthActivity;->a:Landroid/webkit/WebView;

    invoke-virtual {v1, v5}, Landroid/webkit/WebView;->setVerticalScrollbarOverlay(Z)V

    .line 103
    iget-object v1, p0, Lcom/alipay/sdk/app/H5AuthActivity;->a:Landroid/webkit/WebView;

    new-instance v2, Lcom/alipay/sdk/app/H5AuthActivity$a;

    invoke-direct {v2, p0, v6}, Lcom/alipay/sdk/app/H5AuthActivity$a;-><init>(Lcom/alipay/sdk/app/H5AuthActivity;B)V

    invoke-virtual {v1, v2}, Landroid/webkit/WebView;->setWebViewClient(Landroid/webkit/WebViewClient;)V

    .line 104
    iget-object v1, p0, Lcom/alipay/sdk/app/H5AuthActivity;->a:Landroid/webkit/WebView;

    new-instance v2, Lcom/alipay/sdk/app/a;

    invoke-direct {v2, p0}, Lcom/alipay/sdk/app/a;-><init>(Lcom/alipay/sdk/app/H5AuthActivity;)V

    invoke-virtual {v1, v2}, Landroid/webkit/WebView;->setDownloadListener(Landroid/webkit/DownloadListener;)V

    .line 116
    iget-object v1, p0, Lcom/alipay/sdk/app/H5AuthActivity;->a:Landroid/webkit/WebView;

    invoke-virtual {v1, v0}, Landroid/webkit/WebView;->loadUrl(Ljava/lang/String;)V

    .line 118
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/4 v1, 0x7

    if-lt v0, v1, :cond_3

    .line 120
    :try_start_2
    iget-object v0, p0, Lcom/alipay/sdk/app/H5AuthActivity;->a:Landroid/webkit/WebView;

    invoke-virtual {v0}, Landroid/webkit/WebView;->getSettings()Landroid/webkit/WebSettings;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v0

    const-string v1, "setDomStorageEnabled"

    const/4 v2, 0x1

    new-array v2, v2, [Ljava/lang/Class;

    const/4 v3, 0x0

    sget-object v4, Ljava/lang/Boolean;->TYPE:Ljava/lang/Class;

    aput-object v4, v2, v3

    invoke-virtual {v0, v1, v2}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v0

    .line 122
    if-eqz v0, :cond_3

    .line 123
    iget-object v1, p0, Lcom/alipay/sdk/app/H5AuthActivity;->a:Landroid/webkit/WebView;

    invoke-virtual {v1}, Landroid/webkit/WebView;->getSettings()Landroid/webkit/WebSettings;

    move-result-object v1

    const/4 v2, 0x1

    new-array v2, v2, [Ljava/lang/Object;

    const/4 v3, 0x0

    const/4 v4, 0x1

    invoke-static {v4}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v4

    aput-object v4, v2, v3

    invoke-virtual {v0, v1, v2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_3

    .line 129
    :cond_3
    :goto_1
    :try_start_3
    iget-object v0, p0, Lcom/alipay/sdk/app/H5AuthActivity;->a:Landroid/webkit/WebView;

    invoke-virtual {v0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v0

    const-string v1, "removeJavascriptInterface"

    const/4 v2, 0x0

    new-array v2, v2, [Ljava/lang/Class;

    invoke-virtual {v0, v1, v2}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v0

    .line 131
    if-eqz v0, :cond_0

    .line 132
    iget-object v1, p0, Lcom/alipay/sdk/app/H5AuthActivity;->a:Landroid/webkit/WebView;

    const/4 v2, 0x1

    new-array v2, v2, [Ljava/lang/Object;

    const/4 v3, 0x0

    const-string v4, "searchBoxJavaBridge_"

    aput-object v4, v2, v3

    invoke-virtual {v0, v1, v2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 134
    iget-object v1, p0, Lcom/alipay/sdk/app/H5AuthActivity;->a:Landroid/webkit/WebView;

    const/4 v2, 0x1

    new-array v2, v2, [Ljava/lang/Object;

    const/4 v3, 0x0

    const-string v4, "accessibility"

    aput-object v4, v2, v3

    invoke-virtual {v0, v1, v2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 135
    iget-object v1, p0, Lcom/alipay/sdk/app/H5AuthActivity;->a:Landroid/webkit/WebView;

    const/4 v2, 0x1

    new-array v2, v2, [Ljava/lang/Object;

    const/4 v3, 0x0

    const-string v4, "accessibilityTraversal"

    aput-object v4, v2, v3

    invoke-virtual {v0, v1, v2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_3
    .catch Ljava/lang/Exception; {:try_start_3 .. :try_end_3} :catch_2

    goto/16 :goto_0

    .line 139
    :catch_2
    move-exception v0

    goto/16 :goto_0

    :catch_3
    move-exception v0

    goto :goto_1
.end method

.method protected onDestroy()V
    .locals 2

    .prologue
    const/4 v1, 0x0

    .line 333
    invoke-super {p0}, Landroid/app/Activity;->onDestroy()V

    .line 334
    iget-object v0, p0, Lcom/alipay/sdk/app/H5AuthActivity;->a:Landroid/webkit/WebView;

    if-eqz v0, :cond_0

    .line 335
    iget-object v0, p0, Lcom/alipay/sdk/app/H5AuthActivity;->a:Landroid/webkit/WebView;

    invoke-virtual {v0}, Landroid/webkit/WebView;->removeAllViews()V

    .line 338
    :try_start_0
    iget-object v0, p0, Lcom/alipay/sdk/app/H5AuthActivity;->a:Landroid/webkit/WebView;

    invoke-virtual {v0}, Landroid/webkit/WebView;->destroy()V
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    .line 340
    :goto_0
    iput-object v1, p0, Lcom/alipay/sdk/app/H5AuthActivity;->a:Landroid/webkit/WebView;

    .line 341
    iput-object v1, p0, Lcom/alipay/sdk/app/H5AuthActivity;->a:Landroid/webkit/WebView;

    .line 343
    :cond_0
    return-void

    :catch_0
    move-exception v0

    goto :goto_0
.end method
