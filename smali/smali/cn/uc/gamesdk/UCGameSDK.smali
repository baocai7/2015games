.class public Lcn/uc/gamesdk/UCGameSDK;
.super Ljava/lang/Object;


# static fields
.field private static final CLASS_NAME:Ljava/lang/String; = "UCGameSDK"

.field private static final LOG_SRC:Ljava/lang/String; = "sdk"

.field private static _instance:Lcn/uc/gamesdk/UCGameSDK;

.field private static debugConfig:Landroid/os/Bundle;

.field private static defaultUcid:I

.field private static mOrientation:Lcn/uc/gamesdk/UCOrientation;


# instance fields
.field private loginFaceType:Lcn/uc/gamesdk/UCLoginFaceType;

.field private ucLogLevel:Lcn/uc/gamesdk/UCLogLevel;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    const/4 v0, 0x0

    sput-object v0, Lcn/uc/gamesdk/UCGameSDK;->_instance:Lcn/uc/gamesdk/UCGameSDK;

    sget-object v0, Lcn/uc/gamesdk/UCOrientation;->PORTRAIT:Lcn/uc/gamesdk/UCOrientation;

    sput-object v0, Lcn/uc/gamesdk/UCGameSDK;->mOrientation:Lcn/uc/gamesdk/UCOrientation;

    const/4 v0, 0x0

    sput v0, Lcn/uc/gamesdk/UCGameSDK;->defaultUcid:I

    new-instance v0, Landroid/os/Bundle;

    invoke-direct {v0}, Landroid/os/Bundle;-><init>()V

    sput-object v0, Lcn/uc/gamesdk/UCGameSDK;->debugConfig:Landroid/os/Bundle;

    return-void
.end method

.method private constructor <init>()V
    .locals 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    iput-object v0, p0, Lcn/uc/gamesdk/UCGameSDK;->ucLogLevel:Lcn/uc/gamesdk/UCLogLevel;

    sget-object v0, Lcn/uc/gamesdk/UCLoginFaceType;->USE_WIDGET:Lcn/uc/gamesdk/UCLoginFaceType;

    iput-object v0, p0, Lcn/uc/gamesdk/UCGameSDK;->loginFaceType:Lcn/uc/gamesdk/UCLoginFaceType;

    return-void
.end method

.method static synthetic a()Landroid/os/Bundle;
    .locals 1

    sget-object v0, Lcn/uc/gamesdk/UCGameSDK;->debugConfig:Landroid/os/Bundle;

    return-object v0
.end method

.method static synthetic a(Lcn/uc/gamesdk/UCGameSDK;)Lcn/uc/gamesdk/UCLoginFaceType;
    .locals 1

    iget-object v0, p0, Lcn/uc/gamesdk/UCGameSDK;->loginFaceType:Lcn/uc/gamesdk/UCLoginFaceType;

    return-object v0
.end method

.method static synthetic b(Lcn/uc/gamesdk/UCGameSDK;)Lcn/uc/gamesdk/UCLogLevel;
    .locals 1

    iget-object v0, p0, Lcn/uc/gamesdk/UCGameSDK;->ucLogLevel:Lcn/uc/gamesdk/UCLogLevel;

    return-object v0
.end method

.method static synthetic b()Lcn/uc/gamesdk/UCOrientation;
    .locals 1

    sget-object v0, Lcn/uc/gamesdk/UCGameSDK;->mOrientation:Lcn/uc/gamesdk/UCOrientation;

    return-object v0
.end method

.method public static declared-synchronized defaultSDK()Lcn/uc/gamesdk/UCGameSDK;
    .locals 2

    const-class v1, Lcn/uc/gamesdk/UCGameSDK;

    monitor-enter v1

    :try_start_0
    sget-object v0, Lcn/uc/gamesdk/UCGameSDK;->_instance:Lcn/uc/gamesdk/UCGameSDK;

    if-nez v0, :cond_0

    new-instance v0, Lcn/uc/gamesdk/UCGameSDK;

    invoke-direct {v0}, Lcn/uc/gamesdk/UCGameSDK;-><init>()V

    sput-object v0, Lcn/uc/gamesdk/UCGameSDK;->_instance:Lcn/uc/gamesdk/UCGameSDK;

    :cond_0
    sget-object v0, Lcn/uc/gamesdk/UCGameSDK;->_instance:Lcn/uc/gamesdk/UCGameSDK;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit v1

    return-object v0

    :catchall_0
    move-exception v0

    monitor-exit v1

    throw v0
.end method


# virtual methods
.method public bindGuest(Lcn/uc/gamesdk/UCCallbackListener;)V
    .locals 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lcn/uc/gamesdk/UCCallbackListener",
            "<",
            "Ljava/lang/String;",
            ">;)V"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcn/uc/gamesdk/UCCallbackListenerNullException;
        }
    .end annotation

    const/4 v3, 0x0

    const-string v0, "activateGuest"

    const-string v1, "enter"

    const-string v2, ""

    invoke-static {v0, v1, v2}, Lcn/uc/a/a/a/i;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    if-nez p1, :cond_0

    new-instance v0, Lcn/uc/gamesdk/UCCallbackListenerNullException;

    const-string v1, "\u6e38\u5ba2\u6fc0\u6d3b\u4fa6\u542c\u5668 (listener) \u4e3a\u7a7a\uff01"

    invoke-direct {v0, v1}, Lcn/uc/gamesdk/UCCallbackListenerNullException;-><init>(Ljava/lang/String;)V

    throw v0

    :cond_0
    invoke-static {}, Lcn/uc/gamesdk/b/a;->a()Lcn/uc/gamesdk/b/a;

    move-result-object v0

    sget-object v1, Lcn/uc/gamesdk/iface/Commands;->BindGuest:Lcn/uc/gamesdk/iface/Commands;

    invoke-virtual {v0, v1}, Lcn/uc/gamesdk/b/a;->a(Lcn/uc/gamesdk/iface/Commands;)Lcn/uc/gamesdk/iface/IDispatcher;

    move-result-object v0

    if-nez v0, :cond_1

    const-string v0, "UCGameSDK"

    const-string v1, "bindGuest"

    const-string v2, "\u5c1a\u672a\u521d\u59cb\u5316\uff0c\u4e0d\u80fd\u8c03\u7528bindGuest\u63a5\u53e3"

    invoke-static {v0, v1, v2}, Lcn/uc/a/a/a/i;->c(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const/16 v0, -0xa

    const-string v1, "\u5c1a\u672a\u521d\u59cb\u5316\uff0c\u4e0d\u80fd\u8c03\u7528bindGuest\u63a5\u53e3"

    invoke-interface {p1, v0, v1}, Lcn/uc/gamesdk/UCCallbackListener;->callback(ILjava/lang/Object;)V

    :goto_0
    return-void

    :cond_1
    sget-object v1, Lcn/uc/gamesdk/iface/Commands;->BindGuest:Lcn/uc/gamesdk/iface/Commands;

    invoke-interface {v0, v1, v3, v3, p1}, Lcn/uc/gamesdk/iface/IDispatcher;->invoke(Lcn/uc/gamesdk/iface/Commands;Landroid/os/Bundle;Landroid/app/Activity;Lcn/uc/gamesdk/UCCallbackListener;)Landroid/os/Bundle;

    goto :goto_0
.end method

.method public createFloatButton(Landroid/app/Activity;Lcn/uc/gamesdk/UCCallbackListener;)V
    .locals 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/app/Activity;",
            "Lcn/uc/gamesdk/UCCallbackListener",
            "<",
            "Ljava/lang/String;",
            ">;)V"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcn/uc/gamesdk/UCCallbackListenerNullException;,
            Lcn/uc/gamesdk/UCFloatButtonCreateException;
        }
    .end annotation

    const/4 v3, 0x0

    if-nez p2, :cond_0

    new-instance v0, Lcn/uc/gamesdk/UCCallbackListenerNullException;

    const-string v1, "SDK\u754c\u9762\u6d88\u606f\u4fa6\u542c\u5668 (sdkListener) \u4e3a\u7a7a\uff01"

    invoke-direct {v0, v1}, Lcn/uc/gamesdk/UCCallbackListenerNullException;-><init>(Ljava/lang/String;)V

    throw v0

    :cond_0
    invoke-virtual {p1}, Landroid/app/Activity;->getApplicationContext()Landroid/content/Context;

    move-result-object v0

    sput-object v0, Lcn/uc/gamesdk/a/d;->b:Landroid/content/Context;

    invoke-static {}, Lcn/uc/gamesdk/b/a;->a()Lcn/uc/gamesdk/b/a;

    move-result-object v0

    sget-object v1, Lcn/uc/gamesdk/iface/Commands;->CreateFloatButton:Lcn/uc/gamesdk/iface/Commands;

    invoke-virtual {v0, v1}, Lcn/uc/gamesdk/b/a;->a(Lcn/uc/gamesdk/iface/Commands;)Lcn/uc/gamesdk/iface/IDispatcher;

    move-result-object v0

    if-nez v0, :cond_1

    const-string v0, "UCGameSDK"

    const-string v1, "createFloatButton"

    const-string v2, "\u5c1a\u672a\u521d\u59cb\u5316\uff0c\u4e0d\u80fd\u8c03\u7528createFloatButton\u63a5\u53e3"

    invoke-static {v0, v1, v2}, Lcn/uc/a/a/a/i;->c(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const/16 v0, -0xa

    invoke-interface {p2, v0, v3}, Lcn/uc/gamesdk/UCCallbackListener;->callback(ILjava/lang/Object;)V

    :goto_0
    return-void

    :cond_1
    sget-object v1, Lcn/uc/gamesdk/iface/Commands;->CreateFloatButton:Lcn/uc/gamesdk/iface/Commands;

    invoke-interface {v0, v1, v3, p1, p2}, Lcn/uc/gamesdk/iface/IDispatcher;->invoke(Lcn/uc/gamesdk/iface/Commands;Landroid/os/Bundle;Landroid/app/Activity;Lcn/uc/gamesdk/UCCallbackListener;)Landroid/os/Bundle;

    goto :goto_0
.end method

.method public destoryFloatButton(Landroid/app/Activity;)V
    .locals 3

    const/4 v2, 0x0

    invoke-virtual {p1}, Landroid/app/Activity;->getApplicationContext()Landroid/content/Context;

    move-result-object v0

    sput-object v0, Lcn/uc/gamesdk/a/d;->b:Landroid/content/Context;

    invoke-static {}, Lcn/uc/gamesdk/b/a;->a()Lcn/uc/gamesdk/b/a;

    move-result-object v0

    sget-object v1, Lcn/uc/gamesdk/iface/Commands;->DestroyFloatButton:Lcn/uc/gamesdk/iface/Commands;

    invoke-virtual {v0, v1}, Lcn/uc/gamesdk/b/a;->a(Lcn/uc/gamesdk/iface/Commands;)Lcn/uc/gamesdk/iface/IDispatcher;

    move-result-object v0

    if-nez v0, :cond_0

    const-string v0, "UCGameSDK"

    const-string v1, "destroyFloatButton"

    const-string v2, "\u5c1a\u672a\u521d\u59cb\u5316\uff0c\u4e0d\u80fd\u8c03\u7528destroyFloatButton\u63a5\u53e3"

    invoke-static {v0, v1, v2}, Lcn/uc/a/a/a/i;->c(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    :goto_0
    return-void

    :cond_0
    sget-object v1, Lcn/uc/gamesdk/iface/Commands;->DestroyFloatButton:Lcn/uc/gamesdk/iface/Commands;

    invoke-interface {v0, v1, v2, p1, v2}, Lcn/uc/gamesdk/iface/IDispatcher;->invoke(Lcn/uc/gamesdk/iface/Commands;Landroid/os/Bundle;Landroid/app/Activity;Lcn/uc/gamesdk/UCCallbackListener;)Landroid/os/Bundle;

    goto :goto_0
.end method

.method public enterUI(Landroid/content/Context;Ljava/lang/String;Lcn/uc/gamesdk/UCCallbackListener;)V
    .locals 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Context;",
            "Ljava/lang/String;",
            "Lcn/uc/gamesdk/UCCallbackListener",
            "<",
            "Ljava/lang/String;",
            ">;)V"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcn/uc/gamesdk/UCCallbackListenerNullException;
        }
    .end annotation

    const-string v0, "enter"

    const-string v1, ""

    invoke-static {p2, v0, v1}, Lcn/uc/a/a/a/i;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "\u4e1a\u52a1("

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, " )"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    if-nez p3, :cond_0

    new-instance v1, Lcn/uc/gamesdk/UCCallbackListenerNullException;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v2, "\u56de\u8c03\u4fa6\u542c\u5668\uff08listener\uff09\u4e3a\u7a7a\uff01"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {v1, v0}, Lcn/uc/gamesdk/UCCallbackListenerNullException;-><init>(Ljava/lang/String;)V

    throw v1

    :cond_0
    invoke-virtual {p1}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object v0

    sput-object v0, Lcn/uc/gamesdk/a/d;->b:Landroid/content/Context;

    new-instance v0, Landroid/os/Bundle;

    invoke-direct {v0}, Landroid/os/Bundle;-><init>()V

    const-string v1, "business"

    invoke-virtual {v0, v1, p2}, Landroid/os/Bundle;->putString(Ljava/lang/String;Ljava/lang/String;)V

    invoke-static {}, Lcn/uc/gamesdk/b/a;->a()Lcn/uc/gamesdk/b/a;

    move-result-object v1

    sget-object v2, Lcn/uc/gamesdk/iface/Commands;->EnterUI:Lcn/uc/gamesdk/iface/Commands;

    invoke-virtual {v1, v2}, Lcn/uc/gamesdk/b/a;->a(Lcn/uc/gamesdk/iface/Commands;)Lcn/uc/gamesdk/iface/IDispatcher;

    move-result-object v1

    if-nez v1, :cond_1

    const-string v0, "UCGameSDK"

    const-string v1, "enterUI"

    const-string v2, "\u5c1a\u672a\u521d\u59cb\u5316\uff0c\u4e0d\u80fd\u8c03\u7528enterUI\u63a5\u53e3"

    invoke-static {v0, v1, v2}, Lcn/uc/a/a/a/i;->c(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const/16 v0, -0xa

    const-string v1, "\u5c1a\u672a\u521d\u59cb\u5316\uff0c\u8bf7\u521d\u59cb\u5316\u540e\u518d\u8c03\u7528enterUI\u63a5\u53e3"

    invoke-interface {p3, v0, v1}, Lcn/uc/gamesdk/UCCallbackListener;->callback(ILjava/lang/Object;)V

    :goto_0
    return-void

    :cond_1
    sget-object v2, Lcn/uc/gamesdk/iface/Commands;->EnterUI:Lcn/uc/gamesdk/iface/Commands;

    const/4 v3, 0x0

    invoke-interface {v1, v2, v0, v3, p3}, Lcn/uc/gamesdk/iface/IDispatcher;->invoke(Lcn/uc/gamesdk/iface/Commands;Landroid/os/Bundle;Landroid/app/Activity;Lcn/uc/gamesdk/UCCallbackListener;)Landroid/os/Bundle;

    goto :goto_0
.end method

.method public enterUserCenter(Landroid/content/Context;Lcn/uc/gamesdk/UCCallbackListener;)V
    .locals 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Context;",
            "Lcn/uc/gamesdk/UCCallbackListener",
            "<",
            "Ljava/lang/String;",
            ">;)V"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcn/uc/gamesdk/UCCallbackListenerNullException;
        }
    .end annotation

    const/4 v3, 0x0

    const-string v0, "userCenter"

    const-string v1, "enter"

    const-string v2, ""

    invoke-static {v0, v1, v2}, Lcn/uc/a/a/a/i;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    if-nez p2, :cond_0

    new-instance v0, Lcn/uc/gamesdk/UCCallbackListenerNullException;

    const-string v1, "\u4e5d\u6e38\u793e\u533a\u56de\u8c03\u4fa6\u542c\u5668\uff08listener\uff09\u4e3a\u7a7a\uff01"

    invoke-direct {v0, v1}, Lcn/uc/gamesdk/UCCallbackListenerNullException;-><init>(Ljava/lang/String;)V

    throw v0

    :cond_0
    invoke-virtual {p1}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object v0

    sput-object v0, Lcn/uc/gamesdk/a/d;->b:Landroid/content/Context;

    invoke-static {}, Lcn/uc/gamesdk/a;->a()Lcn/uc/gamesdk/a;

    move-result-object v0

    invoke-virtual {p1}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcn/uc/gamesdk/a;->a(Landroid/content/Context;)Lcn/uc/gamesdk/a;

    invoke-static {}, Lcn/uc/gamesdk/b/a;->a()Lcn/uc/gamesdk/b/a;

    move-result-object v0

    sget-object v1, Lcn/uc/gamesdk/iface/Commands;->EnterUserCenter:Lcn/uc/gamesdk/iface/Commands;

    invoke-virtual {v0, v1}, Lcn/uc/gamesdk/b/a;->a(Lcn/uc/gamesdk/iface/Commands;)Lcn/uc/gamesdk/iface/IDispatcher;

    move-result-object v0

    if-nez v0, :cond_1

    const-string v0, "UCGameSDK"

    const-string v1, "enterUserCenter"

    const-string v2, "\u5c1a\u672a\u521d\u59cb\u5316\uff0c\u4e0d\u80fd\u8c03\u7528enterUserCenter\u63a5\u53e3"

    invoke-static {v0, v1, v2}, Lcn/uc/a/a/a/i;->c(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const/16 v0, -0xa

    invoke-interface {p2, v0, v3}, Lcn/uc/gamesdk/UCCallbackListener;->callback(ILjava/lang/Object;)V

    :goto_0
    return-void

    :cond_1
    sget-object v1, Lcn/uc/gamesdk/iface/Commands;->EnterUserCenter:Lcn/uc/gamesdk/iface/Commands;

    invoke-interface {v0, v1, v3, v3, p2}, Lcn/uc/gamesdk/iface/IDispatcher;->invoke(Lcn/uc/gamesdk/iface/Commands;Landroid/os/Bundle;Landroid/app/Activity;Lcn/uc/gamesdk/UCCallbackListener;)Landroid/os/Bundle;

    goto :goto_0
.end method

.method public enterUserCenter(Landroid/content/Context;Lcn/uc/gamesdk/UCCallbackListener;Lcn/uc/gamesdk/info/ExInfo;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Context;",
            "Lcn/uc/gamesdk/UCCallbackListener",
            "<",
            "Ljava/lang/String;",
            ">;",
            "Lcn/uc/gamesdk/info/ExInfo;",
            ")V"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcn/uc/gamesdk/UCCallbackListenerNullException;
        }
    .end annotation

    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    invoke-virtual {p0, p1, p2}, Lcn/uc/gamesdk/UCGameSDK;->enterUserCenter(Landroid/content/Context;Lcn/uc/gamesdk/UCCallbackListener;)V

    return-void
.end method

.method public exitSDK()V
    .locals 1
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    const/4 v0, 0x0

    invoke-virtual {p0, v0, v0}, Lcn/uc/gamesdk/UCGameSDK;->exitSDK(Landroid/app/Activity;Lcn/uc/gamesdk/UCCallbackListener;)V

    return-void
.end method

.method public exitSDK(Landroid/app/Activity;Lcn/uc/gamesdk/UCCallbackListener;)V
    .locals 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/app/Activity;",
            "Lcn/uc/gamesdk/UCCallbackListener",
            "<",
            "Ljava/lang/String;",
            ">;)V"
        }
    .end annotation

    invoke-static {}, Lcn/uc/gamesdk/b/a;->a()Lcn/uc/gamesdk/b/a;

    move-result-object v0

    sget-object v1, Lcn/uc/gamesdk/iface/Commands;->ExitSdk:Lcn/uc/gamesdk/iface/Commands;

    invoke-virtual {v0, v1}, Lcn/uc/gamesdk/b/a;->a(Lcn/uc/gamesdk/iface/Commands;)Lcn/uc/gamesdk/iface/IDispatcher;

    move-result-object v0

    if-nez v0, :cond_0

    const-string v0, "UCGameSDK"

    const-string v1, "exitSDK"

    const-string v2, "\u5c1a\u672a\u521d\u59cb\u5316\uff0c\u4e0d\u80fd\u8c03\u7528exitSDK\u63a5\u53e3"

    invoke-static {v0, v1, v2}, Lcn/uc/a/a/a/i;->c(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const/16 v0, -0x2be

    const-string v1, "\u5c1a\u672a\u521d\u59cb\u5316\uff0c\u4e0d\u80fd\u8c03\u7528exitSDK\u63a5\u53e3"

    invoke-interface {p2, v0, v1}, Lcn/uc/gamesdk/UCCallbackListener;->callback(ILjava/lang/Object;)V

    :goto_0
    return-void

    :cond_0
    sget-object v1, Lcn/uc/gamesdk/iface/Commands;->ExitSdk:Lcn/uc/gamesdk/iface/Commands;

    const/4 v2, 0x0

    invoke-interface {v0, v1, v2, p1, p2}, Lcn/uc/gamesdk/iface/IDispatcher;->invoke(Lcn/uc/gamesdk/iface/Commands;Landroid/os/Bundle;Landroid/app/Activity;Lcn/uc/gamesdk/UCCallbackListener;)Landroid/os/Bundle;

    goto :goto_0
.end method

.method public getSid()Ljava/lang/String;
    .locals 4

    const/4 v1, 0x0

    invoke-static {}, Lcn/uc/gamesdk/b/a;->a()Lcn/uc/gamesdk/b/a;

    move-result-object v0

    sget-object v2, Lcn/uc/gamesdk/iface/Commands;->GetSid:Lcn/uc/gamesdk/iface/Commands;

    invoke-virtual {v0, v2}, Lcn/uc/gamesdk/b/a;->a(Lcn/uc/gamesdk/iface/Commands;)Lcn/uc/gamesdk/iface/IDispatcher;

    move-result-object v2

    if-nez v2, :cond_1

    const-string v0, "UCGameSDK"

    const-string v2, "getsid"

    const-string v3, "\u5c1a\u672a\u521d\u59cb\u5316\uff0c\u4e0d\u80fd\u8c03\u7528getsid\u529f\u80fd"

    invoke-static {v0, v2, v3}, Lcn/uc/a/a/a/i;->c(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    move-object v0, v1

    :cond_0
    :goto_0
    return-object v0

    :cond_1
    const-string v0, ""

    sget-object v3, Lcn/uc/gamesdk/iface/Commands;->GetSid:Lcn/uc/gamesdk/iface/Commands;

    invoke-interface {v2, v3, v1, v1, v1}, Lcn/uc/gamesdk/iface/IDispatcher;->invoke(Lcn/uc/gamesdk/iface/Commands;Landroid/os/Bundle;Landroid/app/Activity;Lcn/uc/gamesdk/UCCallbackListener;)Landroid/os/Bundle;

    move-result-object v1

    const-string v2, "status"

    invoke-virtual {v1, v2}, Landroid/os/Bundle;->getInt(Ljava/lang/String;)I

    move-result v2

    if-nez v2, :cond_0

    const-string v0, "sid"

    invoke-virtual {v1, v0}, Landroid/os/Bundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    goto :goto_0
.end method

.method public getUCVipInfo(Landroid/content/Context;Lcn/uc/gamesdk/UCCallbackListener;)V
    .locals 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Context;",
            "Lcn/uc/gamesdk/UCCallbackListener",
            "<",
            "Lcn/uc/gamesdk/info/VipInfo;",
            ">;)V"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcn/uc/gamesdk/UCCallbackListenerNullException;
        }
    .end annotation

    const/4 v3, 0x0

    const-string v0, "getUCVipInfo"

    const-string v1, "enter"

    const-string v2, ""

    invoke-static {v0, v1, v2}, Lcn/uc/a/a/a/i;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    if-nez p2, :cond_0

    new-instance v0, Lcn/uc/gamesdk/UCCallbackListenerNullException;

    const-string v1, "\u662f\u5426\u4f1a\u5458\u63a5\u53e3\u56de\u8c03\u4fa6\u542c\u5668\uff08listener\uff09\u4e3a\u7a7a\uff01"

    invoke-direct {v0, v1}, Lcn/uc/gamesdk/UCCallbackListenerNullException;-><init>(Ljava/lang/String;)V

    throw v0

    :cond_0
    new-instance v0, Lcn/uc/gamesdk/UCGameSDK$3;

    invoke-direct {v0, p0, p2}, Lcn/uc/gamesdk/UCGameSDK$3;-><init>(Lcn/uc/gamesdk/UCGameSDK;Lcn/uc/gamesdk/UCCallbackListener;)V

    invoke-virtual {p1}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object v1

    sput-object v1, Lcn/uc/gamesdk/a/d;->b:Landroid/content/Context;

    invoke-static {}, Lcn/uc/gamesdk/b/a;->a()Lcn/uc/gamesdk/b/a;

    move-result-object v1

    sget-object v2, Lcn/uc/gamesdk/iface/Commands;->GetUCVipInfo:Lcn/uc/gamesdk/iface/Commands;

    invoke-virtual {v1, v2}, Lcn/uc/gamesdk/b/a;->a(Lcn/uc/gamesdk/iface/Commands;)Lcn/uc/gamesdk/iface/IDispatcher;

    move-result-object v1

    if-nez v1, :cond_1

    const-string v0, "UCGameSDK"

    const-string v1, "getUCVipInfo"

    const-string v2, "\u5c1a\u672a\u521d\u59cb\u5316\uff0c\u4e0d\u80fd\u8c03\u7528getUCVipInfo\u63a5\u53e3"

    invoke-static {v0, v1, v2}, Lcn/uc/a/a/a/i;->c(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const/16 v0, -0xa

    invoke-interface {p2, v0, v3}, Lcn/uc/gamesdk/UCCallbackListener;->callback(ILjava/lang/Object;)V

    :goto_0
    return-void

    :cond_1
    sget-object v2, Lcn/uc/gamesdk/iface/Commands;->GetUCVipInfo:Lcn/uc/gamesdk/iface/Commands;

    invoke-interface {v1, v2, v3, v3, v0}, Lcn/uc/gamesdk/iface/IDispatcher;->invoke(Lcn/uc/gamesdk/iface/Commands;Landroid/os/Bundle;Landroid/app/Activity;Lcn/uc/gamesdk/UCCallbackListener;)Landroid/os/Bundle;

    goto :goto_0
.end method

.method public getVipInfo(Landroid/content/Context;Lcn/uc/gamesdk/UCCallbackListener;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Context;",
            "Lcn/uc/gamesdk/UCCallbackListener",
            "<",
            "Lcn/uc/gamesdk/info/VipInfo;",
            ">;)V"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcn/uc/gamesdk/UCCallbackListenerNullException;
        }
    .end annotation

    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    invoke-virtual {p0, p1, p2}, Lcn/uc/gamesdk/UCGameSDK;->getUCVipInfo(Landroid/content/Context;Lcn/uc/gamesdk/UCCallbackListener;)V

    return-void
.end method

.method public initSDK(Landroid/app/Activity;Lcn/uc/gamesdk/UCLogLevel;ZLcn/uc/gamesdk/info/GameParamInfo;Lcn/uc/gamesdk/UCCallbackListener;)V
    .locals 9
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/app/Activity;",
            "Lcn/uc/gamesdk/UCLogLevel;",
            "Z",
            "Lcn/uc/gamesdk/info/GameParamInfo;",
            "Lcn/uc/gamesdk/UCCallbackListener",
            "<",
            "Ljava/lang/String;",
            ">;)V"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcn/uc/gamesdk/UCCallbackListenerNullException;
        }
    .end annotation

    const/4 v2, 0x0

    const/4 v3, 0x1

    const-string v0, ""

    const-string v1, "\u6b63\u5728\u521d\u59cb\u5316"

    invoke-static {p1, v0, v1, v3}, Landroid/app/ProgressDialog;->show(Landroid/content/Context;Ljava/lang/CharSequence;Ljava/lang/CharSequence;Z)Landroid/app/ProgressDialog;

    move-result-object v7

    invoke-virtual {v7, v2}, Landroid/app/ProgressDialog;->setCancelable(Z)V

    if-nez p5, :cond_0

    new-instance v0, Lcn/uc/gamesdk/UCCallbackListenerNullException;

    const-string v1, "\u521d\u59cb\u5316\u56de\u8c03\u4fa6\u542c\u5668\uff08listener\uff09\u4e3a\u7a7a\uff01"

    invoke-direct {v0, v1}, Lcn/uc/gamesdk/UCCallbackListenerNullException;-><init>(Ljava/lang/String;)V

    throw v0

    :cond_0
    if-nez p1, :cond_1

    new-instance v0, Lcn/uc/gamesdk/UCCallbackListenerNullException;

    const-string v1, "\u5e94\u7528\u4e0a\u4e0b\u6587\uff08ctx\uff09\u4e0d\u80fd\u4e3a\u7a7a\uff01"

    invoke-direct {v0, v1}, Lcn/uc/gamesdk/UCCallbackListenerNullException;-><init>(Ljava/lang/String;)V

    throw v0

    :cond_1
    sput-object p4, Lcn/uc/gamesdk/a/d;->c:Lcn/uc/gamesdk/info/GameParamInfo;

    invoke-virtual {p1}, Landroid/app/Activity;->getApplicationContext()Landroid/content/Context;

    move-result-object v0

    sput-object v0, Lcn/uc/gamesdk/a/d;->b:Landroid/content/Context;

    sput-boolean p3, Lcn/uc/gamesdk/a/d;->g:Z

    sget-object v0, Lcn/uc/gamesdk/UCGameSDK;->mOrientation:Lcn/uc/gamesdk/UCOrientation;

    sput-object v0, Lcn/uc/gamesdk/a/d;->h:Lcn/uc/gamesdk/UCOrientation;

    invoke-static {p1}, Lcn/uc/a/a/a/a;->a(Landroid/content/Context;)V

    const-string v0, "key_gameId"

    invoke-virtual {p4}, Lcn/uc/gamesdk/info/GameParamInfo;->getGameId()I

    move-result v1

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-static {v0, v1}, Lcn/uc/a/a/a/a;->a(Ljava/lang/String;Ljava/lang/Integer;)V

    const-string v0, "key_server_id"

    invoke-virtual {p4}, Lcn/uc/gamesdk/info/GameParamInfo;->getServerId()I

    move-result v1

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-static {v0, v1}, Lcn/uc/a/a/a/a;->a(Ljava/lang/String;Ljava/lang/Integer;)V

    const-string v0, "key_server_name"

    invoke-virtual {p4}, Lcn/uc/gamesdk/info/GameParamInfo;->getServerName()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Lcn/uc/a/a/a/a;->a(Ljava/lang/String;Ljava/lang/String;)V

    const-string v0, "key_cp_id"

    invoke-virtual {p4}, Lcn/uc/gamesdk/info/GameParamInfo;->getCpId()I

    move-result v1

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-static {v0, v1}, Lcn/uc/a/a/a/a;->a(Ljava/lang/String;Ljava/lang/Integer;)V

    const-string v0, "key_using_widget"

    invoke-static {v3}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v1

    invoke-static {v0, v1}, Lcn/uc/a/a/a/a;->a(Ljava/lang/String;Ljava/lang/Boolean;)V

    const-string v0, "key_open_behaviors_logs"

    invoke-static {v3}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v1

    invoke-static {v0, v1}, Lcn/uc/a/a/a/a;->a(Ljava/lang/String;Ljava/lang/Boolean;)V

    const-string v0, "key_ucid"

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-static {v0, v1}, Lcn/uc/a/a/a/a;->a(Ljava/lang/String;Ljava/lang/Integer;)V

    const-string v0, "key_mve"

    sget-object v1, Lcn/uc/gamesdk/a/a;->a:Ljava/lang/String;

    invoke-static {v0, v1}, Lcn/uc/a/a/a/a;->a(Ljava/lang/String;Ljava/lang/String;)V

    const-string v0, "key_ve"

    sget-object v1, Lcn/uc/gamesdk/a/a;->b:Ljava/lang/String;

    invoke-static {v0, v1}, Lcn/uc/a/a/a/a;->a(Ljava/lang/String;Ljava/lang/String;)V

    const-string v0, "key_rootDir"

    invoke-static {}, Lcn/uc/a/a/a/b/h;->a()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Lcn/uc/a/a/a/a;->a(Ljava/lang/String;Ljava/lang/String;)V

    if-eqz p3, :cond_2

    sget-object v0, Lcn/uc/gamesdk/UCGameSDK;->debugConfig:Landroid/os/Bundle;

    const-string v1, "debugHost"

    invoke-virtual {v0, v1}, Landroid/os/Bundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcn/uc/a/a/a/a/k;->a(Ljava/lang/String;)V

    :goto_0
    const-string v0, "sdk"

    invoke-static {v0}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;)V

    const-string v0, "dexSDKInit"

    const-string v1, "enter"

    const-string v2, ""

    invoke-static {v0, v1, v2, v3}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Z)V

    const-string v0, "dexLoading"

    const-string v1, "enter"

    const-string v2, ""

    invoke-static {v0, v1, v2, v3}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Z)V

    new-instance v8, Ljava/lang/Thread;

    new-instance v0, Lcn/uc/gamesdk/UCGameSDK$1;

    move-object v1, p0

    move-object v2, p1

    move-object v3, p4

    move v4, p3

    move-object v5, p2

    move-object v6, p5

    invoke-direct/range {v0 .. v7}, Lcn/uc/gamesdk/UCGameSDK$1;-><init>(Lcn/uc/gamesdk/UCGameSDK;Landroid/app/Activity;Lcn/uc/gamesdk/info/GameParamInfo;ZLcn/uc/gamesdk/UCLogLevel;Lcn/uc/gamesdk/UCCallbackListener;Landroid/app/ProgressDialog;)V

    invoke-direct {v8, v0}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    invoke-virtual {v8}, Ljava/lang/Thread;->start()V

    return-void

    :cond_2
    const-string v0, "sdk.g.uc.cn"

    invoke-static {v0}, Lcn/uc/a/a/a/a/k;->a(Ljava/lang/String;)V

    goto :goto_0
.end method

.method public isUCVip(Landroid/content/Context;Lcn/uc/gamesdk/UCCallbackListener;)V
    .locals 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Context;",
            "Lcn/uc/gamesdk/UCCallbackListener",
            "<",
            "Ljava/lang/Boolean;",
            ">;)V"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcn/uc/gamesdk/UCCallbackListenerNullException;
        }
    .end annotation

    const/4 v3, 0x0

    const-string v0, "isUCVip"

    const-string v1, "enter"

    const-string v2, ""

    invoke-static {v0, v1, v2}, Lcn/uc/a/a/a/i;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    if-nez p2, :cond_0

    new-instance v0, Lcn/uc/gamesdk/UCCallbackListenerNullException;

    const-string v1, "\u662f\u5426\u4f1a\u5458\u63a5\u53e3\u56de\u8c03\u4fa6\u542c\u5668\uff08listener\uff09\u4e3a\u7a7a\uff01"

    invoke-direct {v0, v1}, Lcn/uc/gamesdk/UCCallbackListenerNullException;-><init>(Ljava/lang/String;)V

    throw v0

    :cond_0
    invoke-virtual {p1}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object v0

    sput-object v0, Lcn/uc/gamesdk/a/d;->b:Landroid/content/Context;

    invoke-static {}, Lcn/uc/gamesdk/b/a;->a()Lcn/uc/gamesdk/b/a;

    move-result-object v0

    sget-object v1, Lcn/uc/gamesdk/iface/Commands;->IsUCVip:Lcn/uc/gamesdk/iface/Commands;

    invoke-virtual {v0, v1}, Lcn/uc/gamesdk/b/a;->a(Lcn/uc/gamesdk/iface/Commands;)Lcn/uc/gamesdk/iface/IDispatcher;

    move-result-object v0

    if-nez v0, :cond_1

    const-string v0, "UCGameSDK"

    const-string v1, "isUCVip"

    const-string v2, "\u5c1a\u672a\u521d\u59cb\u5316\uff0c\u4e0d\u80fd\u8c03\u7528isUCVip\u63a5\u53e3"

    invoke-static {v0, v1, v2}, Lcn/uc/a/a/a/i;->c(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const/16 v0, -0xa

    invoke-interface {p2, v0, v3}, Lcn/uc/gamesdk/UCCallbackListener;->callback(ILjava/lang/Object;)V

    :goto_0
    return-void

    :cond_1
    sget-object v1, Lcn/uc/gamesdk/iface/Commands;->IsUCVip:Lcn/uc/gamesdk/iface/Commands;

    invoke-interface {v0, v1, v3, v3, p2}, Lcn/uc/gamesdk/iface/IDispatcher;->invoke(Lcn/uc/gamesdk/iface/Commands;Landroid/os/Bundle;Landroid/app/Activity;Lcn/uc/gamesdk/UCCallbackListener;)Landroid/os/Bundle;

    goto :goto_0
.end method

.method public isVip(Landroid/content/Context;Lcn/uc/gamesdk/UCCallbackListener;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Context;",
            "Lcn/uc/gamesdk/UCCallbackListener",
            "<",
            "Ljava/lang/Boolean;",
            ">;)V"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcn/uc/gamesdk/UCCallbackListenerNullException;
        }
    .end annotation

    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    invoke-virtual {p0, p1, p2}, Lcn/uc/gamesdk/UCGameSDK;->isUCVip(Landroid/content/Context;Lcn/uc/gamesdk/UCCallbackListener;)V

    return-void
.end method

.method public login(Landroid/app/Activity;ILcn/uc/gamesdk/UCCallbackListener;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/app/Activity;",
            "I",
            "Lcn/uc/gamesdk/UCCallbackListener",
            "<",
            "Ljava/lang/String;",
            ">;)V"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcn/uc/gamesdk/UCCallbackListenerNullException;
        }
    .end annotation

    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    sput p2, Lcn/uc/gamesdk/UCGameSDK;->defaultUcid:I

    invoke-virtual {p0, p1, p3}, Lcn/uc/gamesdk/UCGameSDK;->login(Landroid/app/Activity;Lcn/uc/gamesdk/UCCallbackListener;)V

    return-void
.end method

.method public login(Landroid/app/Activity;Lcn/uc/gamesdk/UCCallbackListener;)V
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/app/Activity;",
            "Lcn/uc/gamesdk/UCCallbackListener",
            "<",
            "Ljava/lang/String;",
            ">;)V"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcn/uc/gamesdk/UCCallbackListenerNullException;
        }
    .end annotation

    const/4 v0, 0x0

    invoke-virtual {p0, p1, p2, v0, v0}, Lcn/uc/gamesdk/UCGameSDK;->login(Landroid/app/Activity;Lcn/uc/gamesdk/UCCallbackListener;Lcn/uc/gamesdk/IGameUserLogin;Ljava/lang/String;)V

    return-void
.end method

.method public login(Landroid/app/Activity;Lcn/uc/gamesdk/UCCallbackListener;Lcn/uc/gamesdk/IGameUserLogin;Ljava/lang/String;)V
    .locals 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/app/Activity;",
            "Lcn/uc/gamesdk/UCCallbackListener",
            "<",
            "Ljava/lang/String;",
            ">;",
            "Lcn/uc/gamesdk/IGameUserLogin;",
            "Ljava/lang/String;",
            ")V"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcn/uc/gamesdk/UCCallbackListenerNullException;
        }
    .end annotation

    const-string v0, "login"

    const-string v1, "enter"

    const-string v2, ""

    invoke-static {v0, v1, v2}, Lcn/uc/a/a/a/i;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    if-nez p2, :cond_0

    new-instance v0, Lcn/uc/gamesdk/UCCallbackListenerNullException;

    const-string v1, "\u767b\u5f55\u56de\u8c03\u4fa6\u542c\u5668\uff08listener\uff09\u4e3a\u7a7a\uff01"

    invoke-direct {v0, v1}, Lcn/uc/gamesdk/UCCallbackListenerNullException;-><init>(Ljava/lang/String;)V

    throw v0

    :cond_0
    if-eqz p3, :cond_1

    invoke-static {p4}, Lcn/uc/gamesdk/d/f;->c(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_1

    new-instance v0, Lcn/uc/gamesdk/UCCallbackListenerNullException;

    const-string v1, "\u9700\u8981\u652f\u6301\u6e38\u620f\u8001\u8d26\u53f7\u767b\u5f55\u65f6\uff0c\u6e38\u620f\u8001\u5e10\u53f7\u7684\u6807\u9898\u4e0d\u53ef\u4e3a\u7a7a\uff01"

    invoke-direct {v0, v1}, Lcn/uc/gamesdk/UCCallbackListenerNullException;-><init>(Ljava/lang/String;)V

    throw v0

    :cond_1
    invoke-virtual {p1}, Landroid/app/Activity;->getApplicationContext()Landroid/content/Context;

    move-result-object v0

    sput-object v0, Lcn/uc/gamesdk/a/d;->b:Landroid/content/Context;

    invoke-static {}, Lcn/uc/gamesdk/a;->a()Lcn/uc/gamesdk/a;

    move-result-object v0

    invoke-virtual {v0, p3}, Lcn/uc/gamesdk/a;->a(Lcn/uc/gamesdk/IGameUserLogin;)V

    new-instance v0, Landroid/os/Bundle;

    invoke-direct {v0}, Landroid/os/Bundle;-><init>()V

    invoke-static {p4}, Lcn/uc/gamesdk/d/f;->c(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_2

    const-string v1, "gameAccountTitle"

    invoke-virtual {v0, v1, p4}, Landroid/os/Bundle;->putString(Ljava/lang/String;Ljava/lang/String;)V

    :cond_2
    sget v1, Lcn/uc/gamesdk/UCGameSDK;->defaultUcid:I

    if-eqz v1, :cond_3

    const-string v1, "defaultUcid"

    sget v2, Lcn/uc/gamesdk/UCGameSDK;->defaultUcid:I

    invoke-virtual {v0, v1, v2}, Landroid/os/Bundle;->putInt(Ljava/lang/String;I)V

    :cond_3
    invoke-static {}, Lcn/uc/gamesdk/b/a;->a()Lcn/uc/gamesdk/b/a;

    move-result-object v1

    sget-object v2, Lcn/uc/gamesdk/iface/Commands;->Login:Lcn/uc/gamesdk/iface/Commands;

    invoke-virtual {v1, v2}, Lcn/uc/gamesdk/b/a;->a(Lcn/uc/gamesdk/iface/Commands;)Lcn/uc/gamesdk/iface/IDispatcher;

    move-result-object v1

    if-nez v1, :cond_4

    const-string v0, "UCGameSDK"

    const-string v1, "login"

    const-string v2, "\u5c1a\u672a\u521d\u59cb\u5316\uff0c\u4e0d\u80fd\u8c03\u7528\u767b\u5f55\u529f\u80fd"

    invoke-static {v0, v1, v2}, Lcn/uc/a/a/a/i;->c(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const/16 v0, -0xa

    const-string v1, "\u5c1a\u672a\u521d\u59cb\u5316\uff0c\u8bf7\u521d\u59cb\u5316\u540e\u518d\u8c03\u7528\u767b\u5f55\u63a5\u53e3"

    invoke-interface {p2, v0, v1}, Lcn/uc/gamesdk/UCCallbackListener;->callback(ILjava/lang/Object;)V

    :goto_0
    return-void

    :cond_4
    sget-object v2, Lcn/uc/gamesdk/iface/Commands;->Login:Lcn/uc/gamesdk/iface/Commands;

    invoke-interface {v1, v2, v0, p1, p2}, Lcn/uc/gamesdk/iface/IDispatcher;->invoke(Lcn/uc/gamesdk/iface/Commands;Landroid/os/Bundle;Landroid/app/Activity;Lcn/uc/gamesdk/UCCallbackListener;)Landroid/os/Bundle;

    goto :goto_0
.end method

.method public loginGuest(Landroid/content/Context;Lcn/uc/gamesdk/UCCallbackListener;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Context;",
            "Lcn/uc/gamesdk/UCCallbackListener",
            "<",
            "Ljava/lang/String;",
            ">;)V"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcn/uc/gamesdk/UCCallbackListenerNullException;
        }
    .end annotation

    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    return-void
.end method

.method public logout()V
    .locals 3
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcn/uc/gamesdk/UCCallbackListenerNullException;
        }
    .end annotation

    const/4 v2, 0x0

    invoke-static {}, Lcn/uc/gamesdk/b/a;->a()Lcn/uc/gamesdk/b/a;

    move-result-object v0

    sget-object v1, Lcn/uc/gamesdk/iface/Commands;->Logout:Lcn/uc/gamesdk/iface/Commands;

    invoke-virtual {v0, v1}, Lcn/uc/gamesdk/b/a;->a(Lcn/uc/gamesdk/iface/Commands;)Lcn/uc/gamesdk/iface/IDispatcher;

    move-result-object v0

    if-nez v0, :cond_1

    const-string v0, "UCGameSDK"

    const-string v1, "logout"

    const-string v2, "\u5c1a\u672a\u521d\u59cb\u5316\uff0c\u4e0d\u80fd\u8c03\u7528logout\u63a5\u53e3"

    invoke-static {v0, v1, v2}, Lcn/uc/a/a/a/i;->c(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    :cond_0
    :goto_0
    return-void

    :cond_1
    if-eqz v0, :cond_0

    sget-object v1, Lcn/uc/gamesdk/iface/Commands;->Logout:Lcn/uc/gamesdk/iface/Commands;

    invoke-interface {v0, v1, v2, v2, v2}, Lcn/uc/gamesdk/iface/IDispatcher;->invoke(Lcn/uc/gamesdk/iface/Commands;Landroid/os/Bundle;Landroid/app/Activity;Lcn/uc/gamesdk/UCCallbackListener;)Landroid/os/Bundle;

    goto :goto_0
.end method

.method public logout(Lcn/uc/gamesdk/UCCallbackListener;)V
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lcn/uc/gamesdk/UCCallbackListener",
            "<",
            "Ljava/lang/String;",
            ">;)V"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcn/uc/gamesdk/UCCallbackListenerNullException;
        }
    .end annotation

    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    if-nez p1, :cond_0

    new-instance v0, Lcn/uc/gamesdk/UCCallbackListenerNullException;

    const-string v1, "\u9000\u51fa\u767b\u5f55\u56de\u8c03\u4fa6\u542c\u5668\uff08listener\uff09\u4e3a\u7a7a\uff01"

    invoke-direct {v0, v1}, Lcn/uc/gamesdk/UCCallbackListenerNullException;-><init>(Ljava/lang/String;)V

    throw v0

    :cond_0
    invoke-static {}, Lcn/uc/gamesdk/a;->a()Lcn/uc/gamesdk/a;

    move-result-object v0

    invoke-virtual {v0, p1}, Lcn/uc/gamesdk/a;->a(Lcn/uc/gamesdk/UCCallbackListener;)V

    invoke-virtual {p0}, Lcn/uc/gamesdk/UCGameSDK;->logout()V

    return-void
.end method

.method public notifyZone(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 4

    const/4 v3, 0x0

    new-instance v0, Landroid/os/Bundle;

    invoke-direct {v0}, Landroid/os/Bundle;-><init>()V

    const-string v1, "zoneName"

    invoke-virtual {v0, v1, p1}, Landroid/os/Bundle;->putString(Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "roleId"

    invoke-virtual {v0, v1, p2}, Landroid/os/Bundle;->putString(Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "roleName"

    invoke-virtual {v0, v1, p3}, Landroid/os/Bundle;->putString(Ljava/lang/String;Ljava/lang/String;)V

    invoke-static {}, Lcn/uc/gamesdk/b/a;->a()Lcn/uc/gamesdk/b/a;

    move-result-object v1

    sget-object v2, Lcn/uc/gamesdk/iface/Commands;->NotifyZone:Lcn/uc/gamesdk/iface/Commands;

    invoke-virtual {v1, v2}, Lcn/uc/gamesdk/b/a;->a(Lcn/uc/gamesdk/iface/Commands;)Lcn/uc/gamesdk/iface/IDispatcher;

    move-result-object v1

    if-nez v1, :cond_0

    const-string v0, "UCGameSDK"

    const-string v1, "notifyZone"

    const-string v2, "\u5c1a\u672a\u521d\u59cb\u5316\uff0c\u4e0d\u80fd\u8c03\u7528notifyZone\u63a5\u53e3"

    invoke-static {v0, v1, v2}, Lcn/uc/a/a/a/i;->c(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    :goto_0
    return-void

    :cond_0
    sget-object v2, Lcn/uc/gamesdk/iface/Commands;->NotifyZone:Lcn/uc/gamesdk/iface/Commands;

    invoke-interface {v1, v2, v0, v3, v3}, Lcn/uc/gamesdk/iface/IDispatcher;->invoke(Lcn/uc/gamesdk/iface/Commands;Landroid/os/Bundle;Landroid/app/Activity;Lcn/uc/gamesdk/UCCallbackListener;)Landroid/os/Bundle;

    goto :goto_0
.end method

.method public pay(Landroid/content/Context;Lcn/uc/gamesdk/info/PaymentInfo;Lcn/uc/gamesdk/UCCallbackListener;)V
    .locals 5
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Context;",
            "Lcn/uc/gamesdk/info/PaymentInfo;",
            "Lcn/uc/gamesdk/UCCallbackListener",
            "<",
            "Lcn/uc/gamesdk/info/OrderInfo;",
            ">;)V"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcn/uc/gamesdk/UCCallbackListenerNullException;
        }
    .end annotation

    const/4 v4, 0x0

    const-string v0, "pay"

    const-string v1, "enter"

    const-string v2, ""

    invoke-static {v0, v1, v2}, Lcn/uc/a/a/a/i;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    if-nez p3, :cond_0

    new-instance v0, Lcn/uc/gamesdk/UCCallbackListenerNullException;

    const-string v1, "\u5145\u503c\u56de\u8c03\u4fa6\u542c\u5668\uff08listener\uff09\u4e3a\u7a7a\uff01"

    invoke-direct {v0, v1}, Lcn/uc/gamesdk/UCCallbackListenerNullException;-><init>(Ljava/lang/String;)V

    throw v0

    :cond_0
    invoke-virtual {p1}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object v0

    sput-object v0, Lcn/uc/gamesdk/a/d;->b:Landroid/content/Context;

    new-instance v0, Landroid/os/Bundle;

    invoke-direct {v0}, Landroid/os/Bundle;-><init>()V

    invoke-virtual {p2}, Lcn/uc/gamesdk/info/PaymentInfo;->getRoleId()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcn/uc/gamesdk/d/f;->d(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_1

    const-string v1, "roleId"

    invoke-virtual {p2}, Lcn/uc/gamesdk/info/PaymentInfo;->getRoleId()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Landroid/os/Bundle;->putString(Ljava/lang/String;Ljava/lang/String;)V

    :cond_1
    invoke-virtual {p2}, Lcn/uc/gamesdk/info/PaymentInfo;->getRoleName()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcn/uc/gamesdk/d/f;->d(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_2

    const-string v1, "roleName"

    invoke-virtual {p2}, Lcn/uc/gamesdk/info/PaymentInfo;->getRoleName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Landroid/os/Bundle;->putString(Ljava/lang/String;Ljava/lang/String;)V

    :cond_2
    invoke-virtual {p2}, Lcn/uc/gamesdk/info/PaymentInfo;->getGrade()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcn/uc/gamesdk/d/f;->d(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_3

    const-string v1, "roleGrade"

    invoke-virtual {p2}, Lcn/uc/gamesdk/info/PaymentInfo;->getGrade()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Landroid/os/Bundle;->putString(Ljava/lang/String;Ljava/lang/String;)V

    :cond_3
    invoke-virtual {p2}, Lcn/uc/gamesdk/info/PaymentInfo;->getCustomInfo()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcn/uc/gamesdk/d/f;->d(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_4

    const-string v1, "customInfo"

    invoke-virtual {p2}, Lcn/uc/gamesdk/info/PaymentInfo;->getCustomInfo()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Landroid/os/Bundle;->putString(Ljava/lang/String;Ljava/lang/String;)V

    :cond_4
    const-string v1, "amount"

    invoke-virtual {p2}, Lcn/uc/gamesdk/info/PaymentInfo;->getAmount()F

    move-result v2

    invoke-virtual {v0, v1, v2}, Landroid/os/Bundle;->putFloat(Ljava/lang/String;F)V

    const-string v1, "serverId"

    invoke-virtual {p2}, Lcn/uc/gamesdk/info/PaymentInfo;->getServerId()I

    move-result v2

    invoke-virtual {v0, v1, v2}, Landroid/os/Bundle;->putInt(Ljava/lang/String;I)V

    const-string v1, "allowContinuousPay"

    invoke-virtual {p2}, Lcn/uc/gamesdk/info/PaymentInfo;->isAllowContinuousPay()Z

    move-result v2

    invoke-virtual {v0, v1, v2}, Landroid/os/Bundle;->putBoolean(Ljava/lang/String;Z)V

    const-string v1, "notifyUrl"

    invoke-virtual {p2}, Lcn/uc/gamesdk/info/PaymentInfo;->getNotifyUrl()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Landroid/os/Bundle;->putString(Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "transactionNumCP"

    invoke-virtual {p2}, Lcn/uc/gamesdk/info/PaymentInfo;->getTransactionNumCP()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Landroid/os/Bundle;->putString(Ljava/lang/String;Ljava/lang/String;)V

    new-instance v1, Lcn/uc/gamesdk/UCGameSDK$2;

    invoke-direct {v1, p0, p3}, Lcn/uc/gamesdk/UCGameSDK$2;-><init>(Lcn/uc/gamesdk/UCGameSDK;Lcn/uc/gamesdk/UCCallbackListener;)V

    invoke-static {}, Lcn/uc/gamesdk/b/a;->a()Lcn/uc/gamesdk/b/a;

    move-result-object v2

    sget-object v3, Lcn/uc/gamesdk/iface/Commands;->Pay:Lcn/uc/gamesdk/iface/Commands;

    invoke-virtual {v2, v3}, Lcn/uc/gamesdk/b/a;->a(Lcn/uc/gamesdk/iface/Commands;)Lcn/uc/gamesdk/iface/IDispatcher;

    move-result-object v2

    if-nez v2, :cond_5

    const-string v0, "UCGameSDK"

    const-string v1, "pay"

    const-string v2, "\u5c1a\u672a\u521d\u59cb\u5316\uff0c\u4e0d\u80fd\u8c03\u7528\u652f\u4ed8\u529f\u80fd"

    invoke-static {v0, v1, v2}, Lcn/uc/a/a/a/i;->c(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const/16 v0, -0xa

    invoke-interface {p3, v0, v4}, Lcn/uc/gamesdk/UCCallbackListener;->callback(ILjava/lang/Object;)V

    :goto_0
    return-void

    :cond_5
    sget-object v3, Lcn/uc/gamesdk/iface/Commands;->Pay:Lcn/uc/gamesdk/iface/Commands;

    invoke-interface {v2, v3, v0, v4, v1}, Lcn/uc/gamesdk/iface/IDispatcher;->invoke(Lcn/uc/gamesdk/iface/Commands;Landroid/os/Bundle;Landroid/app/Activity;Lcn/uc/gamesdk/UCCallbackListener;)Landroid/os/Bundle;

    goto :goto_0
.end method

.method public setAlternateDebugHost(Ljava/lang/String;)V
    .locals 2
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    sget-object v0, Lcn/uc/gamesdk/UCGameSDK;->debugConfig:Landroid/os/Bundle;

    const-string v1, "debugHost"

    invoke-virtual {v0, v1, p1}, Landroid/os/Bundle;->putString(Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method public setBindOperation(Lcn/uc/gamesdk/IUCBindGuest;)V
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcn/uc/gamesdk/UCBindGuestNullException;
        }
    .end annotation

    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    return-void
.end method

.method public setDebugConfig(Lorg/json/JSONObject;)V
    .locals 4
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    const/4 v3, 0x1

    if-nez p1, :cond_1

    :cond_0
    :goto_0
    return-void

    :cond_1
    const-string v0, "rexInitEnable"

    invoke-virtual {p1, v0}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_2

    sget-object v0, Lcn/uc/gamesdk/UCGameSDK;->debugConfig:Landroid/os/Bundle;

    const-string v1, "rexInitEnable"

    const-string v2, "rexInitEnable"

    invoke-virtual {p1, v2, v3}, Lorg/json/JSONObject;->optBoolean(Ljava/lang/String;Z)Z

    move-result v2

    invoke-virtual {v0, v1, v2}, Landroid/os/Bundle;->putBoolean(Ljava/lang/String;Z)V

    :cond_2
    const-string v0, "rexUpdateEnable"

    invoke-virtual {p1, v0}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_3

    sget-object v0, Lcn/uc/gamesdk/UCGameSDK;->debugConfig:Landroid/os/Bundle;

    const-string v1, "rexUpdateEnable"

    const-string v2, "rexUpdateEnable"

    invoke-virtual {p1, v2, v3}, Lorg/json/JSONObject;->optBoolean(Ljava/lang/String;Z)Z

    move-result v2

    invoke-virtual {v0, v1, v2}, Landroid/os/Bundle;->putBoolean(Ljava/lang/String;Z)V

    :cond_3
    const-string v0, "initRexConfigOption"

    invoke-virtual {p1, v0}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    sget-object v0, Lcn/uc/gamesdk/UCGameSDK;->debugConfig:Landroid/os/Bundle;

    const-string v1, "initRexConfigOption"

    const-string v2, "initRexConfigOption"

    const-string v3, ""

    invoke-virtual {p1, v2, v3}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Landroid/os/Bundle;->putString(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0
.end method

.method public setFullScreen(Z)V
    .locals 0
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    return-void
.end method

.method public setLogLevel(Lcn/uc/gamesdk/UCLogLevel;)V
    .locals 0

    iput-object p1, p0, Lcn/uc/gamesdk/UCGameSDK;->ucLogLevel:Lcn/uc/gamesdk/UCLogLevel;

    return-void
.end method

.method public setLoginLayoutMode(Landroid/content/Context;Lcn/uc/gamesdk/consts/UCLayoutMode;)V
    .locals 0
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    return-void
.end method

.method public setLoginUISwitch(Lcn/uc/gamesdk/UCLoginFaceType;)V
    .locals 0

    iput-object p1, p0, Lcn/uc/gamesdk/UCGameSDK;->loginFaceType:Lcn/uc/gamesdk/UCLoginFaceType;

    return-void
.end method

.method public setLogoutNotifyListener(Lcn/uc/gamesdk/UCCallbackListener;)V
    .locals 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lcn/uc/gamesdk/UCCallbackListener",
            "<",
            "Ljava/lang/String;",
            ">;)V"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcn/uc/gamesdk/UCCallbackListenerNullException;
        }
    .end annotation

    const-string v0, "userCenter"

    const-string v1, "enter"

    const-string v2, ""

    invoke-static {v0, v1, v2}, Lcn/uc/a/a/a/i;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    if-nez p1, :cond_0

    new-instance v0, Lcn/uc/gamesdk/UCCallbackListenerNullException;

    const-string v1, "\u63a5\u6536\u9000\u51fa\u901a\u77e5\u7684\u4fa6\u542c\u5668\uff08logoutListener\uff09\u4e3a\u7a7a\uff01"

    invoke-direct {v0, v1}, Lcn/uc/gamesdk/UCCallbackListenerNullException;-><init>(Ljava/lang/String;)V

    throw v0

    :cond_0
    invoke-static {}, Lcn/uc/gamesdk/a;->a()Lcn/uc/gamesdk/a;

    move-result-object v0

    invoke-virtual {v0, p1}, Lcn/uc/gamesdk/a;->a(Lcn/uc/gamesdk/UCCallbackListener;)V

    return-void
.end method

.method public setOrientation(Lcn/uc/gamesdk/UCOrientation;)V
    .locals 0

    sput-object p1, Lcn/uc/gamesdk/UCGameSDK;->mOrientation:Lcn/uc/gamesdk/UCOrientation;

    return-void
.end method

.method public setUIStyle(Lcn/uc/gamesdk/UCUIStyle;)V
    .locals 0
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    return-void
.end method

.method public showFloatButton(Landroid/app/Activity;DDZ)V
    .locals 4
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcn/uc/gamesdk/UCCallbackListenerNullException;
        }
    .end annotation

    invoke-virtual {p1}, Landroid/app/Activity;->getApplicationContext()Landroid/content/Context;

    move-result-object v0

    sput-object v0, Lcn/uc/gamesdk/a/d;->b:Landroid/content/Context;

    invoke-static {}, Lcn/uc/gamesdk/b/a;->a()Lcn/uc/gamesdk/b/a;

    move-result-object v0

    sget-object v1, Lcn/uc/gamesdk/iface/Commands;->ShowFloatButton:Lcn/uc/gamesdk/iface/Commands;

    invoke-virtual {v0, v1}, Lcn/uc/gamesdk/b/a;->a(Lcn/uc/gamesdk/iface/Commands;)Lcn/uc/gamesdk/iface/IDispatcher;

    move-result-object v0

    if-nez v0, :cond_0

    const-string v0, "UCGameSDK"

    const-string v1, "showFloatButton"

    const-string v2, "\u5c1a\u672a\u521d\u59cb\u5316\uff0c\u4e0d\u80fd\u8c03\u7528showFloatButton\u63a5\u53e3"

    invoke-static {v0, v1, v2}, Lcn/uc/a/a/a/i;->c(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    :goto_0
    return-void

    :cond_0
    new-instance v1, Landroid/os/Bundle;

    invoke-direct {v1}, Landroid/os/Bundle;-><init>()V

    const-string v2, "x"

    invoke-virtual {v1, v2, p2, p3}, Landroid/os/Bundle;->putDouble(Ljava/lang/String;D)V

    const-string v2, "y"

    invoke-virtual {v1, v2, p4, p5}, Landroid/os/Bundle;->putDouble(Ljava/lang/String;D)V

    const-string v2, "visible"

    invoke-virtual {v1, v2, p6}, Landroid/os/Bundle;->putBoolean(Ljava/lang/String;Z)V

    sget-object v2, Lcn/uc/gamesdk/iface/Commands;->ShowFloatButton:Lcn/uc/gamesdk/iface/Commands;

    const/4 v3, 0x0

    invoke-interface {v0, v2, v1, p1, v3}, Lcn/uc/gamesdk/iface/IDispatcher;->invoke(Lcn/uc/gamesdk/iface/Commands;Landroid/os/Bundle;Landroid/app/Activity;Lcn/uc/gamesdk/UCCallbackListener;)Landroid/os/Bundle;

    goto :goto_0
.end method

.method public submitExtendData(Ljava/lang/String;Lorg/json/JSONObject;)V
    .locals 4

    const/4 v3, 0x0

    new-instance v0, Landroid/os/Bundle;

    invoke-direct {v0}, Landroid/os/Bundle;-><init>()V

    const-string v1, "type"

    invoke-virtual {v0, v1, p1}, Landroid/os/Bundle;->putString(Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "data"

    invoke-virtual {p2}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Landroid/os/Bundle;->putString(Ljava/lang/String;Ljava/lang/String;)V

    invoke-static {}, Lcn/uc/gamesdk/b/a;->a()Lcn/uc/gamesdk/b/a;

    move-result-object v1

    sget-object v2, Lcn/uc/gamesdk/iface/Commands;->SubmitExtendData:Lcn/uc/gamesdk/iface/Commands;

    invoke-virtual {v1, v2}, Lcn/uc/gamesdk/b/a;->a(Lcn/uc/gamesdk/iface/Commands;)Lcn/uc/gamesdk/iface/IDispatcher;

    move-result-object v1

    if-nez v1, :cond_0

    const-string v0, "UCGameSDK"

    const-string v1, "submitExtendData"

    const-string v2, "\u5c1a\u672a\u521d\u59cb\u5316\uff0c\u4e0d\u80fd\u8c03\u7528submitExtendData\u63a5\u53e3"

    invoke-static {v0, v1, v2}, Lcn/uc/a/a/a/i;->c(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    :goto_0
    return-void

    :cond_0
    sget-object v2, Lcn/uc/gamesdk/iface/Commands;->SubmitExtendData:Lcn/uc/gamesdk/iface/Commands;

    invoke-interface {v1, v2, v0, v3, v3}, Lcn/uc/gamesdk/iface/IDispatcher;->invoke(Lcn/uc/gamesdk/iface/Commands;Landroid/os/Bundle;Landroid/app/Activity;Lcn/uc/gamesdk/UCCallbackListener;)Landroid/os/Bundle;

    goto :goto_0
.end method

.method public uPointCharge(Landroid/app/Activity;ILcn/uc/gamesdk/UCCallbackListener;)V
    .locals 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/app/Activity;",
            "I",
            "Lcn/uc/gamesdk/UCCallbackListener",
            "<",
            "Ljava/lang/String;",
            ">;)V"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcn/uc/gamesdk/UCCallbackListenerNullException;
        }
    .end annotation

    const-string v0, "uCharge"

    const-string v1, "enter"

    const-string v2, ""

    invoke-static {v0, v1, v2}, Lcn/uc/a/a/a/i;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    if-nez p3, :cond_0

    new-instance v0, Lcn/uc/gamesdk/UCCallbackListenerNullException;

    const-string v1, "U\u70b9\u5145\u503c\u56de\u8c03\u4fa6\u542c\u5668\uff08listener\uff09\u4e3a\u7a7a\uff01"

    invoke-direct {v0, v1}, Lcn/uc/gamesdk/UCCallbackListenerNullException;-><init>(Ljava/lang/String;)V

    throw v0

    :cond_0
    invoke-virtual {p1}, Landroid/app/Activity;->getApplicationContext()Landroid/content/Context;

    move-result-object v0

    sput-object v0, Lcn/uc/gamesdk/a/d;->b:Landroid/content/Context;

    new-instance v0, Landroid/os/Bundle;

    invoke-direct {v0}, Landroid/os/Bundle;-><init>()V

    const-string v1, "serverId"

    invoke-virtual {v0, v1, p2}, Landroid/os/Bundle;->putInt(Ljava/lang/String;I)V

    invoke-static {}, Lcn/uc/gamesdk/b/a;->a()Lcn/uc/gamesdk/b/a;

    move-result-object v1

    sget-object v2, Lcn/uc/gamesdk/iface/Commands;->UPointCharge:Lcn/uc/gamesdk/iface/Commands;

    invoke-virtual {v1, v2}, Lcn/uc/gamesdk/b/a;->a(Lcn/uc/gamesdk/iface/Commands;)Lcn/uc/gamesdk/iface/IDispatcher;

    move-result-object v1

    if-nez v1, :cond_1

    const-string v0, "UCGameSDK"

    const-string v1, "uPointCharge"

    const-string v2, "\u5c1a\u672a\u521d\u59cb\u5316\uff0c\u4e0d\u80fd\u8c03\u7528uPointCharge\u63a5\u53e3"

    invoke-static {v0, v1, v2}, Lcn/uc/a/a/a/i;->c(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const/16 v0, -0xa

    const-string v1, "\u5c1a\u672a\u521d\u59cb\u5316\uff0c\u4e0d\u80fd\u8c03\u7528uPointCharge\u63a5\u53e3"

    invoke-interface {p3, v0, v1}, Lcn/uc/gamesdk/UCCallbackListener;->callback(ILjava/lang/Object;)V

    :goto_0
    return-void

    :cond_1
    sget-object v2, Lcn/uc/gamesdk/iface/Commands;->UPointCharge:Lcn/uc/gamesdk/iface/Commands;

    invoke-interface {v1, v2, v0, p1, p3}, Lcn/uc/gamesdk/iface/IDispatcher;->invoke(Lcn/uc/gamesdk/iface/Commands;Landroid/os/Bundle;Landroid/app/Activity;Lcn/uc/gamesdk/UCCallbackListener;)Landroid/os/Bundle;

    goto :goto_0
.end method
