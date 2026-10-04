.class public Lorg/cocos2dx/lua/UCSdkConfig;
.super Ljava/lang/Object;
.source "UCSdkConfig.java"


# static fields
.field public static cpId:I

.field public static debugMode:Z

.field public static gameId:I

.field public static serverId:I


# direct methods
.method static constructor <clinit>()V
    .locals 2

    .prologue
    const/4 v1, 0x0

    .line 13
    const v0, 0x9c0f

    sput v0, Lorg/cocos2dx/lua/UCSdkConfig;->cpId:I

    .line 14
    const v0, 0x86b03

    sput v0, Lorg/cocos2dx/lua/UCSdkConfig;->gameId:I

    .line 15
    sput v1, Lorg/cocos2dx/lua/UCSdkConfig;->serverId:I

    .line 18
    sput-boolean v1, Lorg/cocos2dx/lua/UCSdkConfig;->debugMode:Z

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .prologue
    .line 9
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method
