.class public Lcn/uc/a/a/a/a/j;
.super Ljava/lang/Object;


# static fields
.field public static final A:I = 0x96

.field public static final B:I = 0xab

.field public static final C:I = -0xa

.field public static final D:I = -0xb

.field private static final E:Ljava/lang/String; = "SdkResponse"

.field private static N:Lcn/uc/a/a/a/a/m; = null

.field public static final a:I = 0x1

.field public static final b:I = 0xb

.field public static final c:I = 0x65

.field public static final d:I = 0x66

.field public static final e:I = -0x1

.field public static final f:I = 0x63

.field public static final g:I = 0x85

.field public static final h:I = 0x86

.field public static final i:I = 0xa

.field public static final j:I = 0xc

.field public static final k:I = 0xd

.field public static final l:I = -0x3

.field public static final m:I = -0x4

.field public static final n:I = -0x5

.field public static final o:I = -0x6

.field public static final p:I = -0x7

.field public static final q:I = -0x8

.field public static final r:I = -0x9

.field public static final s:I = 0x14

.field public static final t:I = 0x15

.field public static final u:I = 0x16

.field public static final v:I = 0x17

.field public static final w:I = 0x18

.field public static final x:I = 0x89

.field public static final y:I = 0x8b

.field public static final z:I = 0x8c


# instance fields
.field private F:J

.field private G:Ljava/lang/String;

.field private H:Z

.field private I:I

.field private J:Ljava/lang/Object;

.field private K:Ljava/lang/String;

.field private L:I

.field private M:Lorg/json/JSONObject;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    const/4 v0, 0x0

    sput-object v0, Lcn/uc/a/a/a/a/j;->N:Lcn/uc/a/a/a/a/m;

    return-void
.end method

.method public constructor <init>(Ljava/lang/String;Ljava/lang/String;)V
    .locals 8

    const/4 v7, 0x0

    const/16 v3, 0xb

    const/4 v6, 0x1

    const/4 v5, 0x0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcn/uc/a/a/a/a/j;->K:Ljava/lang/String;

    if-nez p2, :cond_1

    const-string v0, "\u7f51\u7edc\u5f02\u5e38"

    iput-object v0, p0, Lcn/uc/a/a/a/a/j;->G:Ljava/lang/String;

    invoke-direct {p0}, Lcn/uc/a/a/a/a/j;->q()I

    move-result v0

    iput v0, p0, Lcn/uc/a/a/a/a/j;->I:I

    iput-boolean v5, p0, Lcn/uc/a/a/a/a/j;->H:Z

    iput-object v7, p0, Lcn/uc/a/a/a/a/j;->J:Ljava/lang/Object;

    :goto_0
    iget-boolean v0, p0, Lcn/uc/a/a/a/a/j;->H:Z

    if-nez v0, :cond_0

    iget v0, p0, Lcn/uc/a/a/a/a/j;->I:I

    invoke-virtual {p0, v0}, Lcn/uc/a/a/a/a/j;->b(I)V

    :cond_0
    return-void

    :cond_1
    :try_start_0
    new-instance v0, Lorg/json/JSONObject;

    invoke-direct {v0, p2}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    const-string v1, "state"

    invoke-virtual {v0, v1}, Lorg/json/JSONObject;->getJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v1

    iput-object v1, p0, Lcn/uc/a/a/a/a/j;->M:Lorg/json/JSONObject;

    const-string v2, "code"

    invoke-virtual {v1, v2}, Lorg/json/JSONObject;->getInt(Ljava/lang/String;)I

    move-result v2

    iput v2, p0, Lcn/uc/a/a/a/a/j;->I:I

    const-string v2, "updateFreq"

    invoke-virtual {v1, v2}, Lorg/json/JSONObject;->optInt(Ljava/lang/String;)I

    move-result v2

    iput v2, p0, Lcn/uc/a/a/a/a/j;->L:I

    iget v2, p0, Lcn/uc/a/a/a/a/j;->I:I

    if-ne v2, v3, :cond_2

    :cond_2
    iget v2, p0, Lcn/uc/a/a/a/a/j;->I:I

    if-ne v2, v3, :cond_3

    const-string v2, "ucid.bind.verify"

    invoke-virtual {v2, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_3

    const-string v2, "ucid.user.refreshLogin"

    invoke-virtual {v2, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_3

    const-string v2, "ucid.vip.info"

    invoke-virtual {v2, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_3

    const-string v2, "ucid.sns.getFriends"

    invoke-virtual {v2, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_3

    const-string v2, "ucid.vip.isVip"

    invoke-virtual {v2, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_3

    const-string v2, "system.sdklog"

    invoke-virtual {v2, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_3

    const-string v2, "system.config"

    invoke-virtual {v2, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_3

    const-string v2, "si.apply"

    invoke-virtual {v2, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_3

    const-string v2, "ucid.game.gameData"

    invoke-virtual {v2, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_3

    const-string v2, "msg.tips.list"

    invoke-virtual {v2, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_3

    :cond_3
    sget-object v2, Lcn/uc/a/a/a/a/j;->N:Lcn/uc/a/a/a/a/m;

    if-eqz v2, :cond_4

    new-instance v3, Ljava/lang/Thread;

    new-instance v4, Lcn/uc/a/a/a/a/j$1;

    invoke-direct {v4, p0, v2}, Lcn/uc/a/a/a/a/j$1;-><init>(Lcn/uc/a/a/a/a/j;Lcn/uc/a/a/a/a/m;)V

    invoke-direct {v3, v4}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    invoke-virtual {v3}, Ljava/lang/Thread;->start()V

    :cond_4
    iget v2, p0, Lcn/uc/a/a/a/a/j;->I:I

    if-ne v2, v6, :cond_5

    const/4 v2, 0x1

    iput-boolean v2, p0, Lcn/uc/a/a/a/a/j;->H:Z

    :goto_1
    const-string v2, "msg"

    invoke-virtual {v1, v2}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    iput-object v1, p0, Lcn/uc/a/a/a/a/j;->G:Ljava/lang/String;

    const-string v1, "id"

    invoke-virtual {v0, v1}, Lorg/json/JSONObject;->getLong(Ljava/lang/String;)J

    move-result-wide v1

    iput-wide v1, p0, Lcn/uc/a/a/a/a/j;->F:J

    const-string v1, "data"

    invoke-virtual {v0, v1}, Lorg/json/JSONObject;->get(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    iput-object v0, p0, Lcn/uc/a/a/a/a/j;->J:Ljava/lang/Object;
    :try_end_0
    .catch Lorg/json/JSONException; {:try_start_0 .. :try_end_0} :catch_0

    goto/16 :goto_0

    :catch_0
    move-exception v0

    iput-object v7, p0, Lcn/uc/a/a/a/a/j;->J:Ljava/lang/Object;

    const-string v0, "Json\u6570\u636e\u89e3\u6790\u5931\u8d25"

    iput-object v0, p0, Lcn/uc/a/a/a/a/j;->G:Ljava/lang/String;

    invoke-direct {p0}, Lcn/uc/a/a/a/a/j;->q()I

    move-result v0

    iput v0, p0, Lcn/uc/a/a/a/a/j;->I:I

    iput-boolean v5, p0, Lcn/uc/a/a/a/a/j;->H:Z

    goto/16 :goto_0

    :cond_5
    const/4 v2, 0x0

    :try_start_1
    iput-boolean v2, p0, Lcn/uc/a/a/a/a/j;->H:Z
    :try_end_1
    .catch Lorg/json/JSONException; {:try_start_1 .. :try_end_1} :catch_0

    goto :goto_1
.end method

.method public constructor <init>(ZILjava/lang/String;Lorg/json/JSONObject;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-boolean p1, p0, Lcn/uc/a/a/a/a/j;->H:Z

    iput p2, p0, Lcn/uc/a/a/a/a/j;->I:I

    iput-object p3, p0, Lcn/uc/a/a/a/a/j;->G:Ljava/lang/String;

    iput-object p4, p0, Lcn/uc/a/a/a/a/j;->J:Ljava/lang/Object;

    return-void
.end method

.method static synthetic a(Lcn/uc/a/a/a/a/j;)I
    .locals 1

    iget v0, p0, Lcn/uc/a/a/a/a/j;->L:I

    return v0
.end method

.method public static a(ILjava/lang/String;)Lcn/uc/a/a/a/a/j;
    .locals 3

    new-instance v0, Lcn/uc/a/a/a/a/j;

    const/4 v1, 0x0

    const/4 v2, 0x0

    invoke-direct {v0, v1, p0, p1, v2}, Lcn/uc/a/a/a/a/j;-><init>(ZILjava/lang/String;Lorg/json/JSONObject;)V

    return-object v0
.end method

.method public static a(Ljava/lang/String;)Lcn/uc/a/a/a/a/j;
    .locals 2

    new-instance v0, Lcn/uc/a/a/a/a/j;

    const/4 v1, 0x0

    invoke-direct {v0, p0, v1}, Lcn/uc/a/a/a/a/j;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    return-object v0
.end method

.method public static a(Lorg/json/JSONObject;Ljava/lang/String;)Lcn/uc/a/a/a/a/j;
    .locals 2

    const/4 v1, 0x1

    new-instance v0, Lcn/uc/a/a/a/a/j;

    invoke-direct {v0, v1, v1, p1, p0}, Lcn/uc/a/a/a/a/j;-><init>(ZILjava/lang/String;Lorg/json/JSONObject;)V

    return-object v0
.end method

.method public static a(Lcn/uc/a/a/a/a/m;)V
    .locals 0

    sput-object p0, Lcn/uc/a/a/a/a/j;->N:Lcn/uc/a/a/a/a/m;

    return-void
.end method

.method public static b(ILjava/lang/String;)Lcn/uc/a/a/a/a/j;
    .locals 3

    new-instance v0, Lcn/uc/a/a/a/a/j;

    const/4 v1, 0x1

    const/4 v2, 0x0

    invoke-direct {v0, v1, p0, p1, v2}, Lcn/uc/a/a/a/a/j;-><init>(ZILjava/lang/String;Lorg/json/JSONObject;)V

    return-object v0
.end method

.method public static b(Ljava/lang/String;)Lcn/uc/a/a/a/a/j;
    .locals 4

    new-instance v0, Lcn/uc/a/a/a/a/j;

    const/4 v1, 0x0

    const/4 v2, -0x1

    const/4 v3, 0x0

    invoke-direct {v0, v1, v2, p0, v3}, Lcn/uc/a/a/a/a/j;-><init>(ZILjava/lang/String;Lorg/json/JSONObject;)V

    return-object v0
.end method

.method public static b()Lcn/uc/a/a/a/a/m;
    .locals 1

    sget-object v0, Lcn/uc/a/a/a/a/j;->N:Lcn/uc/a/a/a/a/m;

    return-object v0
.end method

.method public static c(Ljava/lang/String;)Lcn/uc/a/a/a/a/j;
    .locals 4

    new-instance v0, Lcn/uc/a/a/a/a/j;

    const/4 v1, 0x0

    const/4 v2, -0x1

    const/4 v3, 0x0

    invoke-direct {v0, v1, v2, p0, v3}, Lcn/uc/a/a/a/a/j;-><init>(ZILjava/lang/String;Lorg/json/JSONObject;)V

    return-object v0
.end method

.method public static d()I
    .locals 1

    invoke-static {}, Lcn/uc/a/a/a/b/a;->j()Z

    move-result v0

    if-nez v0, :cond_0

    const/4 v0, -0x3

    :goto_0
    return v0

    :cond_0
    const/4 v0, -0x1

    goto :goto_0
.end method

.method private static d(Ljava/lang/String;)Z
    .locals 1

    const-string v0, "system.config"

    invoke-virtual {v0, p0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_0

    const-string v0, "si.apply"

    invoke-virtual {v0, p0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_1

    :cond_0
    const/4 v0, 0x1

    :goto_0
    return v0

    :cond_1
    const/4 v0, 0x0

    goto :goto_0
.end method

.method private q()I
    .locals 1

    invoke-static {}, Lcn/uc/a/a/a/b/a;->j()Z

    move-result v0

    if-nez v0, :cond_0

    const/4 v0, -0x3

    :goto_0
    return v0

    :cond_0
    const/4 v0, -0x5

    goto :goto_0
.end method


# virtual methods
.method public a(I)V
    .locals 0

    iput p1, p0, Lcn/uc/a/a/a/a/j;->L:I

    return-void
.end method

.method public a(Lorg/json/JSONObject;)V
    .locals 0

    iput-object p1, p0, Lcn/uc/a/a/a/a/j;->J:Ljava/lang/Object;

    return-void
.end method

.method public a()Z
    .locals 2

    const/4 v0, 0x1

    iget v1, p0, Lcn/uc/a/a/a/a/j;->I:I

    if-lt v1, v0, :cond_0

    :goto_0
    return v0

    :cond_0
    const/4 v0, 0x0

    goto :goto_0
.end method

.method public b(I)V
    .locals 4

    sparse-switch p1, :sswitch_data_0

    const-string v0, "SdkResponse"

    const-string v1, "logFailCode"

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "\u5931\u8d25\u7684SdkServer\u54cd\u5e94, \u9519\u8bef\u7801="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v0, v1, v2}, Lcn/uc/a/a/a/i;->c(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    :goto_0
    return-void

    :sswitch_0
    const-string v0, "SdkResponse"

    const-string v1, "logFailCode"

    const-string v2, "\u5ba2\u6237\u7aef\u6ca1\u6709\u521d\u59cb\u5316, \u53ef\u80fd\u662f\u670d\u52a1\u5668\u6ca1\u6709\u54cd\u5e94\u5bfc\u81f4"

    invoke-static {v0, v1, v2}, Lcn/uc/a/a/a/i;->c(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0

    :sswitch_1
    const-string v0, "SdkResponse"

    const-string v1, "logFailCode"

    iget-object v2, p0, Lcn/uc/a/a/a/a/j;->G:Ljava/lang/String;

    invoke-static {v0, v1, v2}, Lcn/uc/a/a/a/i;->c(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0

    :sswitch_2
    const-string v0, "SdkResponse"

    const-string v1, "logFailCode"

    const-string v2, "\u6ca1\u6709\u7f51\u7edc"

    invoke-static {v0, v1, v2}, Lcn/uc/a/a/a/i;->c(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0

    :sswitch_3
    const-string v0, "SdkResponse"

    const-string v1, "logFailCode"

    const-string v2, "\u6ca1\u6709\u54cd\u5e94"

    invoke-static {v0, v1, v2}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0

    :sswitch_data_0
    .sparse-switch
        -0x5 -> :sswitch_3
        -0x4 -> :sswitch_0
        -0x3 -> :sswitch_2
        0xb -> :sswitch_1
    .end sparse-switch
.end method

.method public c()I
    .locals 1

    iget v0, p0, Lcn/uc/a/a/a/a/j;->L:I

    return v0
.end method

.method public e()Lcn/uc/a/a/a/a/d;
    .locals 5

    invoke-virtual {p0}, Lcn/uc/a/a/a/a/j;->m()Lorg/json/JSONObject;

    move-result-object v0

    new-instance v1, Lcn/uc/a/a/a/a/d;

    invoke-direct {v1}, Lcn/uc/a/a/a/a/d;-><init>()V

    if-eqz v0, :cond_0

    const-string v2, "openTestGame"

    invoke-virtual {v0, v2}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_0

    const-string v2, "openTestGame"

    invoke-virtual {v0, v2}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v0

    if-eqz v0, :cond_0

    const-string v2, "SdkResponse"

    const-string v3, "getOpenTestStatus"

    const-string v4, "jObjectOpenTestGame"

    invoke-static {v2, v3, v4}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const-string v2, "status"

    invoke-virtual {v0, v2}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    const-string v3, "message"

    invoke-virtual {v0, v3}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v2}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v2

    const-string v3, "A"

    invoke-virtual {v2, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_1

    const/4 v2, 0x1

    iput-boolean v2, v1, Lcn/uc/a/a/a/a/d;->a:Z

    :goto_0
    iput-object v0, v1, Lcn/uc/a/a/a/a/d;->b:Ljava/lang/String;

    :cond_0
    return-object v1

    :cond_1
    const/4 v2, 0x0

    iput-boolean v2, v1, Lcn/uc/a/a/a/a/d;->a:Z

    goto :goto_0
.end method

.method public f()Z
    .locals 1

    invoke-virtual {p0}, Lcn/uc/a/a/a/a/j;->e()Lcn/uc/a/a/a/a/d;

    move-result-object v0

    iget-boolean v0, v0, Lcn/uc/a/a/a/a/d;->a:Z

    return v0
.end method

.method public g()Z
    .locals 4

    const/4 v0, 0x1

    const/4 v1, 0x0

    invoke-virtual {p0}, Lcn/uc/a/a/a/a/j;->m()Lorg/json/JSONObject;

    move-result-object v2

    if-eqz v2, :cond_1

    const-string v3, "isAlpha"

    invoke-virtual {v2, v3}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_1

    const-string v3, "isAlpha"

    invoke-virtual {v2, v3, v1}, Lorg/json/JSONObject;->optInt(Ljava/lang/String;I)I

    move-result v2

    :goto_0
    if-ne v2, v0, :cond_0

    :goto_1
    return v0

    :cond_0
    move v0, v1

    goto :goto_1

    :cond_1
    move v2, v1

    goto :goto_0
.end method

.method public h()I
    .locals 1

    iget v0, p0, Lcn/uc/a/a/a/a/j;->I:I

    return v0
.end method

.method public i()J
    .locals 2

    iget-wide v0, p0, Lcn/uc/a/a/a/a/j;->F:J

    return-wide v0
.end method

.method public j()Ljava/lang/String;
    .locals 1

    iget-object v0, p0, Lcn/uc/a/a/a/a/j;->G:Ljava/lang/String;

    return-object v0
.end method

.method public k()Z
    .locals 1

    iget-boolean v0, p0, Lcn/uc/a/a/a/a/j;->H:Z

    return v0
.end method

.method public l()Ljava/lang/Object;
    .locals 1

    iget-object v0, p0, Lcn/uc/a/a/a/a/j;->J:Ljava/lang/Object;

    return-object v0
.end method

.method public m()Lorg/json/JSONObject;
    .locals 1

    iget-object v0, p0, Lcn/uc/a/a/a/a/j;->J:Ljava/lang/Object;

    check-cast v0, Lorg/json/JSONObject;

    return-object v0
.end method

.method public n()Ljava/lang/String;
    .locals 1

    iget-object v0, p0, Lcn/uc/a/a/a/a/j;->K:Ljava/lang/String;

    return-object v0
.end method

.method public o()Lorg/json/JSONObject;
    .locals 8

    new-instance v7, Lorg/json/JSONObject;

    invoke-direct {v7}, Lorg/json/JSONObject;-><init>()V

    :try_start_0
    const-string v0, "success"

    iget-boolean v1, p0, Lcn/uc/a/a/a/a/j;->H:Z

    invoke-virtual {v7, v0, v1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    const-string v0, "data"

    iget-object v1, p0, Lcn/uc/a/a/a/a/j;->J:Ljava/lang/Object;

    invoke-virtual {v7, v0, v1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    const-string v0, "msg"

    iget-object v1, p0, Lcn/uc/a/a/a/a/j;->G:Ljava/lang/String;

    invoke-virtual {v7, v0, v1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    const-string v0, "code"

    iget v1, p0, Lcn/uc/a/a/a/a/j;->I:I

    invoke-virtual {v7, v0, v1}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    iget-object v0, p0, Lcn/uc/a/a/a/a/j;->M:Lorg/json/JSONObject;

    if-eqz v0, :cond_0

    const-string v0, "state"

    iget-object v1, p0, Lcn/uc/a/a/a/a/j;->M:Lorg/json/JSONObject;

    invoke-virtual {v7, v0, v1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    :try_end_0
    .catch Lorg/json/JSONException; {:try_start_0 .. :try_end_0} :catch_0

    :cond_0
    :goto_0
    return-object v7

    :catch_0
    move-exception v4

    const-string v0, "SdkResponse"

    const-string v1, "toJSONObject"

    const-string v2, "json"

    const-string v3, ""

    const/4 v5, 0x2

    const-string v6, "key_mve"

    invoke-static {v6}, Lcn/uc/a/a/a/a;->c(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    invoke-static/range {v0 .. v6}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Exception;ILjava/lang/String;)V

    goto :goto_0
.end method

.method public p()Ljava/lang/String;
    .locals 1

    invoke-virtual {p0}, Lcn/uc/a/a/a/a/j;->o()Lorg/json/JSONObject;

    move-result-object v0

    invoke-virtual {v0}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method
