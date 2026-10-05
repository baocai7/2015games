.class public Lcom/dygame/open/dataeye/DCLuaCardsGame;
.super Ljava/lang/Object;
.source "DCLuaCardsGame.java"


# static fields
.field private static TAG:Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .prologue
    .line 8
    const-string v0, "DataEye:DCLuaCardsGame"

    sput-object v0, Lcom/dygame/open/dataeye/DCLuaCardsGame;->TAG:Ljava/lang/String;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .prologue
    .line 7
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static gain(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 8
    .param p0, "roomId"    # Ljava/lang/String;
    .param p1, "roomType"    # Ljava/lang/String;
    .param p2, "coinType"    # Ljava/lang/String;
    .param p3, "gain"    # Ljava/lang/String;
    .param p4, "left"    # Ljava/lang/String;

    .prologue
    .line 17
    sget-object v0, Lcom/dygame/open/dataeye/DCLuaCardsGame;->TAG:Ljava/lang/String;

    const-string v1, "gain"

    invoke-static {v0, v1}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 18
    invoke-static {p3}, Ljava/lang/Integer;->valueOf(Ljava/lang/String;)Ljava/lang/Integer;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    int-to-long v4, v0

    invoke-static {p4}, Ljava/lang/Integer;->valueOf(Ljava/lang/String;)Ljava/lang/Integer;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    int-to-long v6, v0

    move-object v1, p0

    move-object v2, p1

    move-object v3, p2

    invoke-static/range {v1 .. v7}, Lcom/dataeye/plugin/DCCardsGame;->gain(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;JJ)V

    .line 19
    return-void
.end method

.method public static lost(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 8
    .param p0, "roomId"    # Ljava/lang/String;
    .param p1, "roomType"    # Ljava/lang/String;
    .param p2, "coinType"    # Ljava/lang/String;
    .param p3, "lost"    # Ljava/lang/String;
    .param p4, "left"    # Ljava/lang/String;

    .prologue
    .line 22
    sget-object v0, Lcom/dygame/open/dataeye/DCLuaCardsGame;->TAG:Ljava/lang/String;

    const-string v1, "lost"

    invoke-static {v0, v1}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 23
    invoke-static {p3}, Ljava/lang/Integer;->valueOf(Ljava/lang/String;)Ljava/lang/Integer;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    int-to-long v4, v0

    invoke-static {p4}, Ljava/lang/Integer;->valueOf(Ljava/lang/String;)Ljava/lang/Integer;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    int-to-long v6, v0

    move-object v1, p0

    move-object v2, p1

    move-object v3, p2

    invoke-static/range {v1 .. v7}, Lcom/dataeye/plugin/DCCardsGame;->lost(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;JJ)V

    .line 24
    return-void
.end method

.method public static play(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 10
    .param p0, "roomId"    # Ljava/lang/String;
    .param p1, "roomType"    # Ljava/lang/String;
    .param p2, "coinType"    # Ljava/lang/String;
    .param p3, "loseOrGain"    # Ljava/lang/String;
    .param p4, "tax"    # Ljava/lang/String;
    .param p5, "left"    # Ljava/lang/String;

    .prologue
    .line 12
    sget-object v0, Lcom/dygame/open/dataeye/DCLuaCardsGame;->TAG:Ljava/lang/String;

    const-string v1, "play"

    invoke-static {v0, v1}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 13
    invoke-static {p3}, Ljava/lang/Integer;->valueOf(Ljava/lang/String;)Ljava/lang/Integer;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    int-to-long v4, v0

    invoke-static {p4}, Ljava/lang/Integer;->valueOf(Ljava/lang/String;)Ljava/lang/Integer;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    int-to-long v6, v0

    invoke-static {p5}, Ljava/lang/Integer;->valueOf(Ljava/lang/String;)Ljava/lang/Integer;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    int-to-long v8, v0

    move-object v1, p0

    move-object v2, p1

    move-object v3, p2

    invoke-static/range {v1 .. v9}, Lcom/dataeye/plugin/DCCardsGame;->play(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;JJJ)V

    .line 14
    return-void
.end method
