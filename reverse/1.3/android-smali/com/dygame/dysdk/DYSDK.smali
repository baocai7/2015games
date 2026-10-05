.class public Lcom/dygame/dysdk/DYSDK;
.super Ljava/lang/Object;
.source "DYSDK.java"


# static fields
.field public static CACHE_NAME:Ljava/lang/String;

.field public static CACHE_PASS:Ljava/lang/String;

.field public static GUEST_NAME:Ljava/lang/String;

.field public static GUEST_PASS:Ljava/lang/String;

.field public static PASS_COOKIE:Ljava/lang/String;

.field public static TEMP_IS_GUEST:Ljava/lang/String;

.field public static TEMP_NAME:Ljava/lang/String;

.field public static TEMP_PASS:Ljava/lang/String;

.field public static TICK_GET_VERIFY:J

.field public static TICK_GET_VERIFY_MAX:J

.field public static URI_BIND_ACCOUNT:Ljava/lang/String;

.field public static URI_GEN_VERIFY:Ljava/lang/String;

.field public static URI_LOGIN:Ljava/lang/String;

.field public static URI_QUICK_REGISTER:Ljava/lang/String;

.field public static URI_REGISTER:Ljava/lang/String;

.field public static URI_RESET:Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .locals 2

    .prologue
    .line 5
    const-string v0, "TEMP_NAME"

    sput-object v0, Lcom/dygame/dysdk/DYSDK;->TEMP_NAME:Ljava/lang/String;

    .line 6
    const-string v0, "TEMP_PASS"

    sput-object v0, Lcom/dygame/dysdk/DYSDK;->TEMP_PASS:Ljava/lang/String;

    .line 7
    const-string v0, "TEMP_IS_GUEST"

    sput-object v0, Lcom/dygame/dysdk/DYSDK;->TEMP_IS_GUEST:Ljava/lang/String;

    .line 9
    const-string v0, ""

    sput-object v0, Lcom/dygame/dysdk/DYSDK;->CACHE_NAME:Ljava/lang/String;

    .line 10
    const-string v0, ""

    sput-object v0, Lcom/dygame/dysdk/DYSDK;->CACHE_PASS:Ljava/lang/String;

    .line 12
    const-string v0, "GEUST_NAME"

    sput-object v0, Lcom/dygame/dysdk/DYSDK;->GUEST_NAME:Ljava/lang/String;

    .line 13
    const-string v0, "GUEST_PASS"

    sput-object v0, Lcom/dygame/dysdk/DYSDK;->GUEST_PASS:Ljava/lang/String;

    .line 14
    const-string v0, "twdasfdm@a837%$6t)921567"

    sput-object v0, Lcom/dygame/dysdk/DYSDK;->PASS_COOKIE:Ljava/lang/String;

    .line 16
    const-string v0, "http://platform.xxxy.dayukeji.com:9999/Plat/plat/onekeyregister/"

    sput-object v0, Lcom/dygame/dysdk/DYSDK;->URI_QUICK_REGISTER:Ljava/lang/String;

    .line 17
    const-string v0, "http://platform.xxxy.dayukeji.com:9999/Plat/plat/getidentifycode/"

    sput-object v0, Lcom/dygame/dysdk/DYSDK;->URI_GEN_VERIFY:Ljava/lang/String;

    .line 18
    const-string v0, "http://platform.xxxy.dayukeji.com:9999/Plat/plat/register/"

    sput-object v0, Lcom/dygame/dysdk/DYSDK;->URI_REGISTER:Ljava/lang/String;

    .line 19
    const-string v0, "http://platform.xxxy.dayukeji.com:9999/Plat/plat/bindaccount/"

    sput-object v0, Lcom/dygame/dysdk/DYSDK;->URI_BIND_ACCOUNT:Ljava/lang/String;

    .line 20
    const-string v0, "http://platform.xxxy.dayukeji.com:9999/Plat/plat/login/"

    sput-object v0, Lcom/dygame/dysdk/DYSDK;->URI_LOGIN:Ljava/lang/String;

    .line 21
    const-string v0, "http://platform.xxxy.dayukeji.com:9999/Plat/plat/resetpassword/"

    sput-object v0, Lcom/dygame/dysdk/DYSDK;->URI_RESET:Ljava/lang/String;

    .line 23
    const-wide/32 v0, 0xea60

    sput-wide v0, Lcom/dygame/dysdk/DYSDK;->TICK_GET_VERIFY_MAX:J

    .line 24
    const-wide/16 v0, 0x0

    sput-wide v0, Lcom/dygame/dysdk/DYSDK;->TICK_GET_VERIFY:J

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .prologue
    .line 4
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method
