.class public final Lcom/alipay/security/mobile/module/a/c/b;
.super Ljava/lang/Object;

# interfaces
.implements Lcom/alipay/security/mobile/module/a/c/a;


# static fields
.field private static a:Lcom/alipay/security/mobile/module/a/c/a;

.field private static b:Lcom/alipay/security/mobile/module/a/a;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    const/4 v0, 0x0

    sput-object v0, Lcom/alipay/security/mobile/module/a/c/b;->a:Lcom/alipay/security/mobile/module/a/c/a;

    sput-object v0, Lcom/alipay/security/mobile/module/a/c/b;->b:Lcom/alipay/security/mobile/module/a/a;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static a(Landroid/content/Context;)Lcom/alipay/security/mobile/module/a/c/a;
    .locals 2

    const/4 v0, 0x0

    if-nez p0, :cond_0

    :goto_0
    return-object v0

    :cond_0
    sget-object v1, Lcom/alipay/security/mobile/module/a/c/b;->a:Lcom/alipay/security/mobile/module/a/c/a;

    if-nez v1, :cond_1

    if-nez p0, :cond_2

    :goto_1
    sput-object v0, Lcom/alipay/security/mobile/module/a/c/b;->b:Lcom/alipay/security/mobile/module/a/a;

    new-instance v0, Lcom/alipay/security/mobile/module/a/c/b;

    invoke-direct {v0}, Lcom/alipay/security/mobile/module/a/c/b;-><init>()V

    sput-object v0, Lcom/alipay/security/mobile/module/a/c/b;->a:Lcom/alipay/security/mobile/module/a/c/a;

    :cond_1
    sget-object v0, Lcom/alipay/security/mobile/module/a/c/b;->a:Lcom/alipay/security/mobile/module/a/c/a;

    goto :goto_0

    :cond_2
    invoke-static {p0}, Lcom/alipay/security/mobile/module/a/b;->a(Landroid/content/Context;)Lcom/alipay/security/mobile/module/a/b;

    move-result-object v0

    goto :goto_1
.end method


# virtual methods
.method public final a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Lcom/alipay/security/mobile/module/a/b/a;
    .locals 4

    sget-object v0, Lcom/alipay/security/mobile/module/a/c/b;->b:Lcom/alipay/security/mobile/module/a/a;

    invoke-interface {v0, p1, p2, p3, p4}, Lcom/alipay/security/mobile/module/a/a;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Lcom/alipay/tscenter/biz/rpc/vkeydfp/result/AppListResult;

    move-result-object v1

    if-nez v1, :cond_0

    const/4 v0, 0x0

    :goto_0
    return-object v0

    :cond_0
    new-instance v0, Lcom/alipay/security/mobile/module/a/b/a;

    iget-object v2, v1, Lcom/alipay/tscenter/biz/rpc/vkeydfp/result/AppListResult;->appListData:Ljava/lang/String;

    iget-object v3, v1, Lcom/alipay/tscenter/biz/rpc/vkeydfp/result/AppListResult;->appListVer:Ljava/lang/String;

    invoke-direct {v0, v2, v3}, Lcom/alipay/security/mobile/module/a/b/a;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    iget-boolean v2, v1, Lcom/alipay/tscenter/biz/rpc/vkeydfp/result/AppListResult;->success:Z

    iput-boolean v2, v0, Lcom/alipay/security/mobile/module/a/b/a;->c:Z

    iget-object v1, v1, Lcom/alipay/tscenter/biz/rpc/vkeydfp/result/AppListResult;->resultCode:Ljava/lang/String;

    iput-object v1, v0, Lcom/alipay/security/mobile/module/a/b/a;->d:Ljava/lang/String;

    goto :goto_0
.end method

.method public final a(Lcom/alipay/security/mobile/module/a/b/d;)Lcom/alipay/security/mobile/module/a/b/c;
    .locals 3

    new-instance v1, Lcom/alipay/tscenter/biz/rpc/vkeydfp/request/DeviceDataReportRequest;

    invoke-direct {v1}, Lcom/alipay/tscenter/biz/rpc/vkeydfp/request/DeviceDataReportRequest;-><init>()V

    iget-object v0, p1, Lcom/alipay/security/mobile/module/a/b/d;->a:Ljava/lang/String;

    invoke-static {v0}, Lcom/alipay/security/mobile/module/commonutils/a;->c(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, v1, Lcom/alipay/tscenter/biz/rpc/vkeydfp/request/DeviceDataReportRequest;->os:Ljava/lang/String;

    iget-object v0, p1, Lcom/alipay/security/mobile/module/a/b/d;->b:Ljava/lang/String;

    invoke-static {v0}, Lcom/alipay/security/mobile/module/commonutils/a;->c(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, v1, Lcom/alipay/tscenter/biz/rpc/vkeydfp/request/DeviceDataReportRequest;->apdid:Ljava/lang/String;

    iget-object v0, p1, Lcom/alipay/security/mobile/module/a/b/d;->c:Ljava/lang/String;

    invoke-static {v0}, Lcom/alipay/security/mobile/module/commonutils/a;->c(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, v1, Lcom/alipay/tscenter/biz/rpc/vkeydfp/request/DeviceDataReportRequest;->pubApdid:Ljava/lang/String;

    iget-object v0, p1, Lcom/alipay/security/mobile/module/a/b/d;->d:Ljava/lang/String;

    invoke-static {v0}, Lcom/alipay/security/mobile/module/commonutils/a;->c(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, v1, Lcom/alipay/tscenter/biz/rpc/vkeydfp/request/DeviceDataReportRequest;->priApdid:Ljava/lang/String;

    iget-object v0, p1, Lcom/alipay/security/mobile/module/a/b/d;->e:Ljava/lang/String;

    invoke-static {v0}, Lcom/alipay/security/mobile/module/commonutils/a;->c(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, v1, Lcom/alipay/tscenter/biz/rpc/vkeydfp/request/DeviceDataReportRequest;->token:Ljava/lang/String;

    iget-object v0, p1, Lcom/alipay/security/mobile/module/a/b/d;->f:Ljava/lang/String;

    invoke-static {v0}, Lcom/alipay/security/mobile/module/commonutils/a;->c(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, v1, Lcom/alipay/tscenter/biz/rpc/vkeydfp/request/DeviceDataReportRequest;->umidToken:Ljava/lang/String;

    iget-object v0, p1, Lcom/alipay/security/mobile/module/a/b/d;->g:Ljava/lang/String;

    invoke-static {v0}, Lcom/alipay/security/mobile/module/commonutils/a;->c(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, v1, Lcom/alipay/tscenter/biz/rpc/vkeydfp/request/DeviceDataReportRequest;->version:Ljava/lang/String;

    iget-object v0, p1, Lcom/alipay/security/mobile/module/a/b/d;->h:Ljava/lang/String;

    invoke-static {v0}, Lcom/alipay/security/mobile/module/commonutils/a;->c(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, v1, Lcom/alipay/tscenter/biz/rpc/vkeydfp/request/DeviceDataReportRequest;->lastTime:Ljava/lang/String;

    iget-object v0, p1, Lcom/alipay/security/mobile/module/a/b/d;->i:Ljava/util/Map;

    if-nez v0, :cond_0

    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    :goto_0
    iput-object v0, v1, Lcom/alipay/tscenter/biz/rpc/vkeydfp/request/DeviceDataReportRequest;->dataMap:Ljava/util/Map;

    sget-object v0, Lcom/alipay/security/mobile/module/a/c/b;->b:Lcom/alipay/security/mobile/module/a/a;

    invoke-interface {v0, v1}, Lcom/alipay/security/mobile/module/a/a;->a(Lcom/alipay/tscenter/biz/rpc/vkeydfp/request/DeviceDataReportRequest;)Lcom/alipay/tscenter/biz/rpc/vkeydfp/result/DeviceDataReportResult;

    move-result-object v1

    new-instance v0, Lcom/alipay/security/mobile/module/a/b/c;

    invoke-direct {v0}, Lcom/alipay/security/mobile/module/a/b/c;-><init>()V

    if-nez v1, :cond_1

    const/4 v0, 0x0

    :goto_1
    return-object v0

    :cond_0
    iget-object v0, p1, Lcom/alipay/security/mobile/module/a/b/d;->i:Ljava/util/Map;

    goto :goto_0

    :cond_1
    iget-boolean v2, v1, Lcom/alipay/tscenter/biz/rpc/vkeydfp/result/DeviceDataReportResult;->success:Z

    iput-boolean v2, v0, Lcom/alipay/security/mobile/module/a/b/c;->c:Z

    iget-object v2, v1, Lcom/alipay/tscenter/biz/rpc/vkeydfp/result/DeviceDataReportResult;->resultCode:Ljava/lang/String;

    iput-object v2, v0, Lcom/alipay/security/mobile/module/a/b/c;->d:Ljava/lang/String;

    iget-object v2, v1, Lcom/alipay/tscenter/biz/rpc/vkeydfp/result/DeviceDataReportResult;->apdid:Ljava/lang/String;

    iput-object v2, v0, Lcom/alipay/security/mobile/module/a/b/c;->a:Ljava/lang/String;

    iget-object v2, v1, Lcom/alipay/tscenter/biz/rpc/vkeydfp/result/DeviceDataReportResult;->token:Ljava/lang/String;

    iput-object v2, v0, Lcom/alipay/security/mobile/module/a/b/c;->b:Ljava/lang/String;

    iget-object v2, v1, Lcom/alipay/tscenter/biz/rpc/vkeydfp/result/DeviceDataReportResult;->currentTime:Ljava/lang/String;

    iput-object v2, v0, Lcom/alipay/security/mobile/module/a/b/c;->e:Ljava/lang/String;

    iget-object v2, v1, Lcom/alipay/tscenter/biz/rpc/vkeydfp/result/DeviceDataReportResult;->version:Ljava/lang/String;

    iput-object v2, v0, Lcom/alipay/security/mobile/module/a/b/c;->f:Ljava/lang/String;

    iget-object v2, v1, Lcom/alipay/tscenter/biz/rpc/vkeydfp/result/DeviceDataReportResult;->vkeySwitch:Ljava/lang/String;

    iput-object v2, v0, Lcom/alipay/security/mobile/module/a/b/c;->g:Ljava/lang/String;

    iget-object v2, v1, Lcom/alipay/tscenter/biz/rpc/vkeydfp/result/DeviceDataReportResult;->bugTrackSwitch:Ljava/lang/String;

    iput-object v2, v0, Lcom/alipay/security/mobile/module/a/b/c;->h:Ljava/lang/String;

    iget-object v1, v1, Lcom/alipay/tscenter/biz/rpc/vkeydfp/result/DeviceDataReportResult;->appListVer:Ljava/lang/String;

    iput-object v1, v0, Lcom/alipay/security/mobile/module/a/b/c;->i:Ljava/lang/String;

    goto :goto_1
.end method

.method public final a(Ljava/lang/String;)Z
    .locals 1

    sget-object v0, Lcom/alipay/security/mobile/module/a/c/b;->b:Lcom/alipay/security/mobile/module/a/a;

    invoke-interface {v0, p1}, Lcom/alipay/security/mobile/module/a/a;->a(Ljava/lang/String;)Z

    move-result v0

    return v0
.end method
