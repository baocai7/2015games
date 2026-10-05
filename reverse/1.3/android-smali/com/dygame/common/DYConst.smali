.class public Lcom/dygame/common/DYConst;
.super Ljava/lang/Object;
.source "DYConst.java"


# static fields
.field public static REQ_CODE_DEFAULT:I

.field public static REQ_CODE_WEIBO:I

.field public static REQ_CODE_WEIXIN:I


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .prologue
    .line 4
    const/16 v0, 0x3e8

    sput v0, Lcom/dygame/common/DYConst;->REQ_CODE_DEFAULT:I

    .line 5
    const/16 v0, 0x3e9

    sput v0, Lcom/dygame/common/DYConst;->REQ_CODE_WEIBO:I

    .line 6
    const/16 v0, 0x3ea

    sput v0, Lcom/dygame/common/DYConst;->REQ_CODE_WEIXIN:I

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .prologue
    .line 3
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method
